// hddcrp_t.cpp : 定义控制台应用程序的入口点。
//
//MY_DEBUG用来展示调试过程，在正常运行时要在stdafx.h中注释掉

#include "stdafx.h"
#include "type_def.h"
#include "HddCRP.hpp"

#include <vector>
#include <iostream>
#include <sys/stat.h>
#include <sys/types.h>
#include <direct.h>
#include "mat.h"
#include "rand_utils.h"

int _tmain(int argc, _TCHAR* argv[])
{
#ifdef MY_DEBUG
	printf("MY_DEBUG Model.\n");
#else
	printf("Running Model.\n");
#endif
////**********************************************************////

if (argc==1)
	{
		cout << "usage: HddCRP trainss.mat prior.mat [K] [alpha0] [alpha1] [alpha2] [num_burn_in] [num_samples] [num_space]" << endl;
		return 0;
	}
	unsigned long init[4]={0x123, 0x234, 0x345, 0x456}, length=4;
	init_by_array(init, length);
	int size_voc_word = 1000;
	double eta_i_word = 1.0/size_voc_word; 
#ifdef TRI_MULT_DIST
	int size_voc_source = 8, size_voc_sink = 8;
	double eta_i_source = 1.0/size_voc_source, eta_i_sink = 1.0/size_voc_sink;
#endif
	vector<double> alphas;
	alphas.push_back(1);
	alphas.push_back(1);
	int num_burn_in = 20, num_samples = 5, num_space = 20;

	if (argc == 1)
	{
		cout << "Usage: " << argv[0] << endl;
		cout << "	-data <train_data_file>" << endl;
		cout << "	-link <link_prior_file>" << endl;
		cout << "	-K <size_code_book>" << endl;
		cout << "	-alpha0 <alpha0>" << endl;
		cout << "	-alpha1 <alpha1>" << endl;
		cout << "	-alpha2 <alpha2>" << endl;
		cout << "	-alpha3 <alpha3>" << endl;
		cout << "	-num_burn_in <num_burn_in>" << endl;
		cout << "	-num_samples <num_samples>" << endl;
		cout << "	-num_space <num_space>" << endl;
		cout << "	[-init_ss <init_ss_file>]" << endl;
		cout << "	[-save_dir <save_dir>]" << endl;
		return 0;
	}

	string trainss_file_name;
	string link_file_name;
	string save_dir;
	bool gen_save_dir = true;
#ifdef TRI_MULT_DIST
	string initss_file_name;
#endif
	istringstream in;

	for (int i = 1; i < argc; i++)
	{
		if (!strcmp(argv[i], "-data"))
		{
			trainss_file_name.assign(argv[++i]);
		}
		else if (!strcmp(argv[i], "-link"))
		{
			link_file_name.assign(argv[++i]);
		}
		else if (!strcmp(argv[i], "-K"))
		{
			in.str(argv[++i]);
			in >> size_voc_word;
			in.clear();
			eta_i_word = 1.0/size_voc_word; 
		}
		else if (!strcmp(argv[i], "-alpha0"))
		{
			double alpha0 = 1.0;
			in.str(argv[++i]);
			in >> alpha0;
			in.clear();
			if (alphas.empty())
			{
				alphas.push_back(alpha0);
			}
			else
			{
				alphas.front() = alpha0;
			}
		}
		else if (!strcmp(argv[i], "-alpha1"))
		{
			double alpha1 = 1.0;
			in.str(argv[++i]);
			in >> alpha1;
			in.clear();
			int sz = alphas.size();
			if (sz > 1)
			{
				alphas.at(1) = alpha1;
			}
			else
			{
				for (int j = 0; j < 1-sz; j++)
				{
					alphas.push_back(1.0);
				}
				alphas.push_back(alpha1);
			}
		}
		else if (!strcmp(argv[i], "-alpha2"))
		{
			double alpha2 = 1.0;
			in.str(argv[++i]);
			in >> alpha2;
			in.clear();
			int sz = alphas.size();
			if (sz > 2)
			{
				alphas.at(2) = alpha2;
			}
			else
			{
				for (int j = 0; j < 2-sz; j++)
				{
					alphas.push_back(1.0);
				}
				alphas.push_back(alpha2);
			}
		}
		else if (!strcmp(argv[i], "-alpha3"))
		{
			double alpha3 = 1.0;
			in.str(argv[++i]);
			in >> alpha3;
			in.clear();
			int sz = alphas.size();
			if (sz > 3)
			{
				alphas.at(3) = alpha3;
			}
			else
			{
				for (int j = 0; j < 3-sz; j++)
				{
					alphas.push_back(1.0);
				}
				alphas.push_back(alpha3);
			}
		}
		else if (!strcmp(argv[i], "-num_burn_in"))
		{
			in.str(argv[++i]);
			in >> num_burn_in;
			in.clear();
		}
		else if (!strcmp(argv[i], "-num_samples"))
		{
			in.str(argv[++i]);
			in >> num_samples;
			in.clear();
		}
		else if (!strcmp(argv[i], "-num_space"))
		{
			in.str(argv[++i]);
			in >> num_space;
			in.clear();
		}
		else if (!strcmp(argv[i], "-save_dir"))
		{
			save_dir.assign(argv[++i]);
			gen_save_dir = false;
		}
#ifdef TRI_MULT_DIST
		else if (!strcmp(argv[i], "-init_ss"))
		{
			initss_file_name.assign(argv[++i]);
		}
#endif
	}


	if (gen_save_dir)
	{
		int pos_name, pos_begin, pos_end;
		if ((pos_name = trainss_file_name.rfind('/')) == string::npos)
		{
			pos_name = 0;
		}
		else
		{
			++pos_name;
		}
		if ((pos_begin = trainss_file_name.find('_', pos_name)) != string::npos)
		{
			++pos_begin;
			if ((pos_end = trainss_file_name.rfind('.')) != string::npos && pos_end >= pos_begin)
			{
				save_dir.assign(trainss_file_name.begin()+pos_begin, trainss_file_name.begin()+pos_end);
			}
		}
		char *dir_name = new char[200];
		if (alphas.size() == 2)
		{
			sprintf(dir_name, "%s_%.1f_%.1e", save_dir.c_str(), alphas.at(0), alphas.at(1));
		}
		else if (alphas.size() == 3)
		{
			sprintf(dir_name, "%s_%.1f_%.1e_%.1e", save_dir.c_str(), alphas.at(0), alphas.at(1), alphas.at(2));
		}
		else
		{
			sprintf(dir_name, "%s_%.1f_%.1e_%.1e_%.1e", save_dir.c_str(), alphas.at(0), alphas.at(1), alphas.at(2), alphas.at(3));
		}
		save_dir.assign(dir_name);
		delete[] dir_name;
	}

	struct stat statbuf;
	if (stat(save_dir.c_str(), &statbuf) != 0)
	{
		mkdir(save_dir.c_str(), S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH);
	}
	else if (S_ISDIR(statbuf.st_mode))
	{
		DIR *dp;
		struct dirent *entry;
		if ((dp = opendir(save_dir.c_str())) == NULL)
		{
			cout << "cannot open " << save_dir << endl;
			return 1;
		}
		chdir(save_dir.c_str());
		while ((entry = readdir(dp)) != NULL)
		{
			lstat(entry->d_name, &statbuf);
			if (!S_ISDIR(statbuf.st_mode))
			{
				remove(entry->d_name);
			}
		}
		chdir("..");
		closedir(dp);
	}
	else
	{
		remove(save_dir.c_str());
		mkdir(save_dir.c_str(), S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH);
	}

////********************************************************////




////*******可调参数**********//
	//在Linux中可以有参数列表进行传输调参
//两层ddcrp 用来处理合成数据集
/*	int size_voc_word = 25;//字典长度
//各层中餐馆模型的离散度参数
//注 ：1e-10 = 0.1
	double alpha0 = 1;
	double alpha1 = 0.01;//1e-200;
	double alpha2 =0.01;
//从num_burn_in开始对起止点标记进行Gibbs采样，总的采样次数是num_samples，间隔num_space 保存中间结果 
	int num_burn_in = 1, num_samples = 100, num_space = 1;
#ifdef LOAD_FROM_TXT
//输入文件夹D:\code\mycode\HDDCRP_T\SyntheticData_GenerationAndVisullization\data
	string inputfile = { "D:/code/mycode/HDDCRP_T/SyntheticData_GenerationAndVisullization/data/" };
#else
	string inputfile = { "D:/code/mycode/HDDCRP_T/SyntheticData_GenerationAndVisullization/data/synthetic_dat_76.mat" };

#endif
//输入文件夹D:\code\mycode\HDDCRP_T\result
	string outputfile = {"D:/code/mycode/HDDCRP_T/result/"};

*/

////*************************//

////*********************************//
//初始化数据和结构体
	double eta_i_word = 1.0 / size_voc_word;

	vector<double> alphas;
	alphas.clear();
	alphas.push_back(alpha0);
	alphas.push_back(alpha1);
	alphas.push_back(alpha2);

//	string trainss_file = inputfile;
//	string link_file;

	HH hh(size_voc_word, eta_i_word);

	HddCRP_Model<DIST> model(hh, alphas, num_burn_in, num_samples, num_space, outputfile);
#ifdef LOAD_FROM_TXT
	model.load_txt_trainss(trainss_file_name);
	model.load_txt_link(link_file_name);
#else
	model.load_matlab_trainss(trainss_file_name);
	model.load_matlab_link(link_file_name);
#endif

	
	model.initialize();
	Layer<DIST>::base.init_log_pos_vals(Layer<DIST>::trainss.size());
	model.run_sampler();


	return 0;
}

