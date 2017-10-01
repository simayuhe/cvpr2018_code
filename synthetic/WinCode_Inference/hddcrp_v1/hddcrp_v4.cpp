// hddcrp_v2.0.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include "mat.h"
#include "rand_utils.h"
#include <vector>
#include <iostream>
#include "type_def.h"				//rename
#include "HddCRP.hpp"			//������HddCRP
#include "string.h"
#include <iostream>
//#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
//#include <dirent.h>
#include <direct.h>
int _tmain(int argc, _TCHAR* argv[])
{
	////*******�ɵ�����**********//
	//����ddcrp ��������ϳ����ݼ�

	////*******�ɵ�����**********//
	//synthetic_dat_76
	int size_voc_word = 25;//�ֵ䳤��

	//�����в͹�ģ�͵���ɢ�Ȳ���
	//ע ��1e-1 = 0.1
	double alpha0 = 5;
	double alpha1 = 2;
	double alpha2 = 1;
	//double alpha3 = 1;

	//��num_burn_in��ʼ����ֹ���ǽ���Gibbs�������ܵĲ���������num_samples�����num_space �����м��� 
	int num_burn_in = 1, num_samples = 100, num_space = 1;

	//�������·��D:\code\mycode\HDDCRP_V3\synthetic\inputdata
	//string T = { "D:/code/mycode/HDDCRP_V3/synthetic/inputdata/synthetic_dat_76.mat" };
	string T = { "D:/code/cvpr2018_code/synthetic/data/docset1/docs76.mat" };
	//string save_dir{ "D:/code/mycode/HDDCRP_V3/synthetic/outputdata/synthetic_dat_tt_V1_1/" };
	string save_dir{ "D:/code/cvpr2018_code/synthetic/result/exper1/" };
	_mkdir("D:/code/cvpr2018_code/synthetic/result/exper1/");
	//*************************//
	double eta_i_word = 1.0 / size_voc_word;
	/*int size_voc_source = 8, size_voc_sink = 8;
	double eta_i_source = 1.0 / size_voc_source, eta_i_sink = 1.0 / size_voc_sink;*/
	vector<double> alphas;
	alphas.clear();
	alphas.push_back(alpha0);
	alphas.push_back(alpha1);
	alphas.push_back(alpha2);
	//alphas.push_back(alpha3);
	string trainss_file_name = T;
	string link_file_name;
	//string initss_file_name = T;

	HH hh(size_voc_word, eta_i_word);
	//HH hh(size_voc_word, eta_i_word, size_voc_source, eta_i_source, size_voc_sink, eta_i_sink);//��ʼ��������
	HddCRP_Model<DIST> model(hh, alphas, num_burn_in, num_samples, num_space, save_dir);
	model.load_matlab_trainss(trainss_file_name);

	model.load_matlab_link(link_file_name);
	model.initialize();
	Layer<DIST>::base.init_log_pos_vals(Layer<DIST>::trainss.size());
	model.run_sampler();

	return 0;
}

