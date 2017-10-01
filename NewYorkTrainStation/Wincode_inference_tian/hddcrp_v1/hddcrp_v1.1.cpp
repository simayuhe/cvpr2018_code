// hddcrp_v1.1.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "mat.h"
#include "rand_utils.h"
#include <vector>
#include <iostream>
#include "type_def.h"				//rename
#include "HddCRP.hpp"			//定义类HddCRP
#include "string.h"
#include <iostream>
//#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
//#include <dirent.h>
#include <direct.h>
int _tmain(int argc, _TCHAR* argv[])
{
	int size_voc_word = 100;//1120;500;//1115//1000; //
	double eta_i_word = 1.0 / size_voc_word;
	int size_voc_source = 8, size_voc_sink = 8;
	double eta_i_source = 1.0 / size_voc_source, eta_i_sink = 1.0 / size_voc_sink;
	vector<double> alphas;
	double alpha0 = .5;
	double alpha1 = 1e-100;//1e-50;//尝试的方法找出优值
	//a1取1e-100 小数据集 58类
	double alpha2 = 1e-50;
	//double alpha3 = 1e-100;
	//double alpha3 = 1;
	alphas.clear();
	alphas.push_back(alpha0);
	alphas.push_back(alpha1);
	alphas.push_back(alpha2);
	//alphas.push_back(alpha3);
	int num_burn_in = 0, num_samples = 100, num_space = 1;

	
	//string T = { "D:/code/mycode/HDDCRP_V1/data_all/forinit.mat" };//D:\Program Files\MATLAB\R2014a\work\mywork\data
	string T = { "D:/code/cvpr2018_code/NewYorkTrainStation/data/minidata/minidata.mat" };
	string trainss_file_name = T;
	string link_file_name = T;
	string initss_file_name = T;
	//string save_dir{ "D:/code/mycode/HDDCRP_V1/result_all/result_1116/" };//D:\Program Files\MATLAB\R2014a\work\ddcrf\result\result_1
	string save_dir{ "D:/code/cvpr2018_code/NewYorkTrainStation/result/exper1/" };
	_mkdir("D:/code/cvpr2018_code/NewYorkTrainStation/result/exper1/"); 
	HH hh(size_voc_word, eta_i_word, size_voc_source, eta_i_source, size_voc_sink, eta_i_sink);//初始化超参数
	HddCRP_Model<DIST> model(hh, alphas, num_burn_in, num_samples, num_space, save_dir);
	model.load_matlab_trainss(trainss_file_name);
	model.load_matlab_link(link_file_name);
	model.initialize();
	Layer<DIST>::base.init_log_pos_vals(Layer<DIST>::trainss.size());
	model.run_sampler();

	return 0;
}

