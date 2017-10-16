#pragma once
//#include "StdAfx.h"
#include "type_def.h"
#include "Multinomial.h"
#include "Tri_Mult.h"
#include "rand_utils.h"
#include <iostream>
#include <math.h>
//#include <mat.h>
#include <vector>
#include <list>
#include <limits.h> //20170824
#include <algorithm>
#include <parallel/algorithm>
#include <functional>
#include <sys/time.h>
#include <cstdlib>
#include <sys/io.h>//20170824
//#include <fcntl.h>
#include <dirent.h>
#include <stdio.h>
#include <errno.h>
#include <string>
#include <string.h>
#include <fnmatch.h>
#include <float.h>
using namespace std;


struct time_used
{
	vector<double> time;
	vector<double> ratio;
	vector<string> name;

	time_used(): time(8, 0.0), ratio(8, 0.0)
	{
		name.push_back("get_cand");
		name.push_back("col_cls");
		name.push_back("col_conn");
		name.push_back("del_data");
		name.push_back("cpt_marg");
		name.push_back("cpt_self");
		name.push_back("samp_cst");
		name.push_back("upd_link");
	}

	void accumulate_time(int i, struct timeval& tv_begin, struct timeval& tv_end)
	{
		time.at(i) += ((tv_end.tv_sec-tv_begin.tv_sec)*1e6+(tv_end.tv_usec-tv_begin.tv_usec))/1e6;
	}

	void compute_ratio()
	{
		double sum = 0.0;
		for (int i = 0; i < time.size(); i++)
		{
			sum += time.at(i);
		}
		for (int i = 0; i < time.size(); i++)
		{
			ratio.at(i) = time.at(i) / sum;
		}
	}

	void print_ratio()
	{
		for (int i = 0; i < ratio.size(); i++)
		{
			cout << "ratio for " << name.at(i) << ":\t\t" << ratio.at(i) << endl;
		}
	}

	time_used& operator+=(time_used& timer)
	{
		for (int i = 0; i < time.size(); i++)
		{
			time.at(i) += timer.time.at(i);
		}
		return *this;
	}

};

typedef time_used Timer;


template<typename D> class Layer
{
public:
	static D base;
	static vector< list<QQ>::iterator > pos_classqq;
	static vector< SS > trainss;
	static vector<int> labels;
	static Layer<D> *top;
	static Layer<D> *bottom;
	static double tot_lik;
#ifdef MY_DEBUG
	static int iter;
	static int cur_layer_no;
#endif
	static Layer<D> *cur_layer;
	static vector<bool> is_computed;
	//static int cur_cluster;
	static void initialize_base();
	static double compute_tot_lik();

	Layer<D> *parent;
	Layer<D> *child;

	int num_groups;
	double alpha_group;
	double alpha_item;
	double log_alpha_group;
	double log_alpha_item;
	vector< vector<int> > group_candidates;
	vector< vector<double> > log_group_priors;
	vector< vector<double> > group_priors;
	vector< vector< vector<int> > > item_candidates;
	vector< vector< vector<double> > > log_item_priors;
	vector< vector< vector<double> > > item_priors;

	vector<int> customers; // customers to which each member links
	vector<int> tables; // tables each member belongs to
	vector<int> old_tables; // tables each member belongs to
	//vector<int> clusters;
	vector< vector<int> > links; // customers from which each member is visited
	vector< list<int> > uni_tables; // unique tables in this restaurant
	vector<int> uni_tables_vec;
	vector< list<int>::iterator > pos_uni_tables; // positions of each table in "uni_tables"

	vector< vector<int> > inds_items; // indices of all customers in this restaurant
	vector<int> inds_groups; // indices of documents each word belongs to

	bool is_self_linked;
	int idx_group_cur;
	int old_customer_cur;
	int new_customer_cur;
	int old_table_cur;
	int new_table_cur;
	int old_cls_cur;
	int new_cls_cur;
	vector<int>::const_iterator connection_start;
	vector<int>::const_iterator connection_end;

	static int cur_item;
	static vector< STAT >::iterator it_stat_cur;
	static QQ qq_temp;
	static vector<double> log_pred_liks;
	static vector<double> pred_liks;
	vector<int> item_cands_cur;
	vector<double> item_priors_cur;
	vector<double> log_item_priors_cur;
	vector<int> cls_cands_cur;
	vector<int> uni_cls_cands_cur;
	double log_self_link_lik;
	vector<double> log_probs_sampling;
	double max_log_prob;

	vector< vector<int> > trees;
	vector< vector<int> > orders;
	vector< vector<STAT> > stats;
	vector< int > inds_start;
	vector< int > inds_end;

#ifdef MY_DEBUG
	struct timeval tv_begin, tv_end;
	struct time_used timer;
#endif

	// functions
	Layer(void){}
	~Layer(void){}
//	void load_matlab_trainss(string& trainss_file);
	int check_txt_number(string & filepath);//20170821
	void load_txt_trainss(string& trainss_file);//20170821
	//void load_txt_SourceSink(string& SourceSink_file);//20170821
//	void load_matlab_link(string& link_file, double _group_alpha);
	void load_txt_link(string& link_file, double _group_alpha);//20170821
	void initialize_link(int num_groups, int num_init_cls);
	void collect_customers();
	void get_candidates();
	void check_link_status();
	void delete_table(int _old_table);
	void add_table();
	void change_table(int _new_table);
	void change_customer(int _new_customer);
	void merge_customers();
	void update_link();
	void remove_items(QQ &qq);
	int get_cluster(int _cur_item);
	void collect_clusters();
	void collect_connections();
	void compute_marg_liks();
	void compute_marg_lik(int c);
	double compute_log_self_link_lik();
	void compute_log_probs_sampling();
	void sample_customer();
	void sample_new_customer();
	void sample_for_single();
	void run_sampler();
	void traverse_single_table(int idx_table);
	void traverse_links();
#ifdef TRI_MULT_DIST
	static int sample_ss(vector<int>& qq, vector<double>& eta, int w);
	static void label_instances();
	static void save_labels(string& save_dir, int iter);
	static void save_topic_labels(string& save_dir, int iter);
	static void sample_source_sink();
	void sample_source_sink_c(int t, int c);
	void update_ss_stats_c(int idx_table);
	void update_ss_stats();
#endif
};

template<typename D> D Layer<D>::base;
template<typename D> vector< list<QQ>::iterator > Layer<D>::pos_classqq;
template<typename D> vector< SS > Layer<D>::trainss;
template<typename D> vector<int> Layer<D>::labels;
template<typename D> Layer<D>* Layer<D>::top = NULL;
template<typename D> Layer<D>* Layer<D>::bottom = NULL;
template<typename D> double Layer<D>::tot_lik;
template<typename D> int Layer<D>::cur_item;
template<typename D> vector< STAT >::iterator Layer<D>::it_stat_cur;
template<typename D> QQ Layer<D>::qq_temp;
template<typename D> vector<bool> Layer<D>::is_computed;
template<typename D> vector<double> Layer<D>::log_pred_liks;
template<typename D> vector<double> Layer<D>::pred_liks;
#ifdef MY_DEBUG
template<typename D> int Layer<D>::iter;
template<typename D> int Layer<D>::cur_layer_no;
#endif
template<typename D> Layer<D>* Layer<D>::cur_layer;

template<typename D> void Layer<D>::initialize_base()
{
	/* add one class and initialize it */
	int tot_num_words = trainss.size();
	pos_classqq.assign(tot_num_words, list<QQ>::iterator());
	pos_classqq.at(0) = base.add_class();

	for (vector<SS>::iterator it_w = trainss.begin(); it_w != trainss.end(); it_w++)
	{
		base.add_data(base.get_classqq().front(), *it_w);
	}

	is_computed.assign(tot_num_words, false);
	log_pred_liks.assign(tot_num_words, 0.0);
	pred_liks.assign(tot_num_words, 0.0);
}

template<typename D> double Layer<D>::compute_tot_lik()
{
	list<int> &uni_tables_0 = top->uni_tables.at(0);
	list<int>::iterator it_t = uni_tables_0.begin();
	tot_lik = 0.0;
	for (; it_t != uni_tables_0.end(); it_t++)
	{
		base.reset_class(qq_temp);
		tot_lik += base.marg_likelihood(qq_temp, top->stats.at(*it_t).front());
	}
	return tot_lik;
}

template<typename D> int Layer<D>::check_txt_number(string& filepath)//20170821
{
	

	DIR *dp;
	struct dirent *dirp;
	int n=0;
	
	dp=opendir(&filepath[0]);
	while ((dirp=readdir(dp))!=NULL  )
	{
		if(!fnmatch("doc_*.txt",dirp->d_name,FNM_PATHNAME|FNM_PERIOD ) )
		{
			n++;
			//printf("%s\n",dirp->d_name);
		}
	}
	//printf("n = %d",n);
	closedir(dp);
/*	char * dir = &filename[0];
	_finddata_t fileDir;
	long lfDir;
	if ((lfDir = _findfirst(dir, &fileDir)) == -1l)
		printf("No file is found\n");
	else{

		do{
			num++;

		} while (_findnext(lfDir, &fileDir) == 0);
		//printf("docs : %d \n", num);
	}
	_findclose(lfDir);
*/
/*	int ij;
	cin>>ij;*/
	return n;

}

#ifdef TRI_MULT_DIST
/*
template<typename D> void Layer<D>::load_matlab_trainss(string& trainss_file)
{
	if (trainss_file.empty())
	{
		num_groups = 1;
		inds_groups.assign(trainss.size(), 0);
	}
	else
	{
		MATFile *pmat = matOpen(trainss_file.c_str(), "r");
		mxArray *pmx_trainss = matGetVariable(pmat, "trainss");
		mxArray *pmx_ss = matGetVariable(pmat, "source_sink");
		mxArray *pmx_doc_i;
		double *pd, *pd_ss = mxGetPr(pmx_ss);
		int i, j, num_words_i, cnt = 0, source, sink;
		const int voc_size_source = base.get_eta().eta_source.size() - 1;
		const int voc_size_sink = base.get_eta().eta_sink.size() - 1;


		 load data from .mat file 
		num_groups = mxGetNumberOfElements(pmx_trainss);
		inds_items.reserve(num_groups);
		labels.assign(num_groups, 0);
		int num_words = 0;
		for (i = 0; i != num_groups; i++)
		{
			pmx_doc_i = mxGetCell(pmx_trainss, i);
			num_words += mxGetNumberOfElements(pmx_doc_i);
		}
		trainss.reserve(num_words);
		inds_groups.reserve(num_words);
	
		for (i = 0; i != num_groups; i++)
		{
			pmx_doc_i = mxGetCell(pmx_trainss, i);
			pd = mxGetPr(pmx_doc_i);
			num_words_i = mxGetNumberOfElements(pmx_doc_i);
			source = (int)(pd_ss[i]) - 1;
			sink = (int)(pd_ss[num_groups+i]) - 1;

			inds_items.push_back(vector<int>());
			vector<int> &inds_items_i = inds_items.back();
			inds_items_i.reserve(num_words_i);
		
			for (j = 0; j != num_words_i; j++)
			{
				trainss.push_back(SS());
				trainss.back().word = (int)(pd[j]-1);

				if (source >= 0)
				{
					trainss.back().source = source;
					trainss.back().gibbs_source = false;
					//if (source > 7){
					//	cout << "invalid" << endl;
					//	int a = 0;
					//}
				}
				else
				{
					trainss.back().source = (int)(genrand_real2()*(double)voc_size_source);
					trainss.back().gibbs_source = true;
					//if (trainss.back().source > 7 || trainss.back().source < 0){
					//	cout << "invalid" << endl;
					//	int a = 0;
					//}
				}

				if (sink >= 0)
				{
					trainss.back().sink = sink; 
					trainss.back().gibbs_sink = false;
					//if (sink > 7){
					//	cout << "invalid" << endl;
					//	int a = 0;
					//}
				}
				else
				{
					trainss.back().sink = (int)(genrand_real2()*(double)voc_size_sink);
					trainss.back().gibbs_sink = true;
					//if (trainss.back().sink > 7 || trainss.back().sink < 0){
					//	cout << "invalid" << endl;
					//	int a = 0;
					//}
				}
				inds_groups.push_back(i);
				inds_items_i.push_back(cnt++);
			}
		}
		matClose(pmat);
	}
}
*/
template<typename D> void Layer<D>::load_txt_trainss(string& trainss_file)
{
	if (trainss_file.empty())
	{
		num_groups = 1;
		inds_groups.assign(trainss.size(), 0);
	}
	else
	{

		//load data from .txt file

		int i, j, num_words_i, cnt = 0;
		const int voc_size_source = base.get_eta().eta_source.size() - 1;
		const int voc_size_sink = base.get_eta().eta_sink.size() - 1;
		num_groups = check_txt_number(trainss_file);
#ifdef MY_DEBUG
		printf("num_groups (number of docs in this inputfile) : %d\n", num_groups);
#endif
		inds_items.reserve(num_groups);
		labels.assign(num_groups, 0);
		int num_words = 0;
		int word_buffer;

		for (i = 0; i != num_groups; i++)
		{
			inds_items.push_back(vector<int>());
			vector<int> &inds_items_i = inds_items.back();
			//inds_items_i.reserve(num_words_i);
	/*		char txtNo[10];
			sprintf(txtNo, "%d", i+1);*/

			ostringstream s1;
			s1 << i+1;
			string s2 = s1.str();

			string txtname = trainss_file + "/doc_" + s2 + ".txt";
			//cout << txtname << endl;
			string SSname = trainss_file+"/ss_" +s2 +".txt";
			int source,sink;
			char * dir_ss = &SSname[0];			
			FILE *fileptr_ss;
			fileptr_ss = fopen(dir_ss, "r");
			fscanf(fileptr_ss, "%d", &source);
			fscanf(fileptr_ss, "%d", &sink);
			fclose(fileptr_ss);
			source=source-1;
			sink=sink-1;

			char * dir = &txtname[0];
			FILE *fileptr;
			fileptr = fopen(dir, "r");
			while (fscanf(fileptr, "%d", &word_buffer) != EOF)//?a????\A8\AE\A8\B2\A1\C1?????\A6̦\CC?\A8\A6\A8\B0??\80?\A8\A8?a\A6̨\A4\A8\BAy\A8\A2?
			{
				trainss.push_back(SS());
				//trainss.push_back(word-1);//word \A8\BA??\A8\AE1\A6\CC?25\A1\EA?o\A8\AE??\A8\AA3???\A8\BA?\A6̦\CC?\A8\BA\A1\C0o\A8\B0\A8\B0a?\A8\AE0\A8\AA3??
				trainss.back().word=word_buffer-1;

				if (source >= 0)
				{
					trainss.back().source = source;
					trainss.back().gibbs_source = false;
					//if (source > 7){
					//	cout << "invalid" << endl;
					//	int a = 0;
					//}
				}
				else
				{
					trainss.back().source = (int)(genrand_real2()*(double)voc_size_source);
					trainss.back().gibbs_source = true;
					//if (trainss.back().source > 7 || trainss.back().source < 0){
					//	cout << "invalid" << endl;
					//	int a = 0;
					//}
				}

				if (sink >= 0)
				{
					trainss.back().sink = sink; 
					trainss.back().gibbs_sink = false;
					//if (sink > 7){
					//	cout << "invalid" << endl;
					//	int a = 0;
					//}
				}
				else
				{
					trainss.back().sink = (int)(genrand_real2()*(double)voc_size_sink);
					trainss.back().gibbs_sink = true;
					//if (trainss.back().sink > 7 || trainss.back().sink < 0){
					//	cout << "invalid" << endl;
					//	int a = 0;
					//}
				}
				inds_groups.push_back(i);
				inds_items_i.push_back(num_words++);
				//printf("num_words \A1\EAo%d", word - 1);
			}
			fclose(fileptr);
		}
		//cin >> j;
	}
}
/*template<typename D> void Layer<D>::load_txt_SourceSink(string& SourceSink_file)//20170821
{
	if (SourceSink_file.empty)
	{
		num_groups = 1;
		inds_groups.assign(trainss.size(), 0);
	}else
	{
	int i, j, num_words_i, cnt = 0, source, sink;
	const int voc_size_source = base.get_eta().eta_source.size() - 1;
	const int voc_size_sink = base.get_eta().eta_sink.size() - 1;
	for (i= 0;i!=num_groups;i++)
	{
		
	}
	}

	
}*/

#else
/*
template<typename D> void Layer<D>::load_matlab_trainss(string& trainss_file)
{
	if (trainss_file.empty())
	{
		num_groups = 1;
		inds_groups.assign(trainss.size(), 0);
	}
	else
	{
		MATFile *pmat = matOpen(trainss_file.c_str(), "r");
		mxArray *pmx_trainss = matGetVariable(pmat, "trainss");
		mxArray *pmx_doc_i;
		double *pd;
		int i, j, num_words_i, cnt = 0;


		// load data from .mat file 
		num_groups = mxGetNumberOfElements(pmx_trainss);
		inds_items.reserve(num_groups);
		labels.assign(num_groups, 0);
		int num_words = 0;
		for (i = 0; i != num_groups; i++)
		{
			pmx_doc_i = mxGetCell(pmx_trainss, i);
			num_words += mxGetNumberOfElements(pmx_doc_i);
		}
		trainss.reserve(num_words);
		inds_groups.reserve(num_words);
	
		for (i = 0; i != num_groups; i++)
		{
			pmx_doc_i = mxGetCell(pmx_trainss, i);
			pd = mxGetPr(pmx_doc_i);
			num_words_i = mxGetNumberOfElements(pmx_doc_i);

			inds_items.push_back(vector<int>());
			vector<int> &inds_items_i = inds_items.back();
			inds_items_i.reserve(num_words_i);
		
			for (j = 0; j != num_words_i; j++)
			{
				trainss.push_back((int)(pd[j]-1));
				inds_groups.push_back(i);
				inds_items_i.push_back(cnt++);
			}
		}
	}
}
*/

template<typename D> void Layer<D>::load_txt_trainss(string& trainss_file)//20170821
{
	if (trainss_file.empty())
	{
		num_groups = 1;
		inds_groups.assign(trainss.size(), 0);
	}
	else
	{
		int i, j, num_words_i, cnt = 0;
		num_groups = check_txt_number(trainss_file);
#ifdef MY_DEBUG
		printf("num_groups (number of docs in this inputfile) : %d\n", num_groups);
#endif
		inds_items.reserve(num_groups);
		labels.assign(num_groups, 0);
		int num_words = 0;
		int word;
		//?a\A8\A4?\A8\BA???\A8\A2?o\A8\B9?\A8\A4reverse\A6\CC??\A1\A4?\A8\B2\A1\EA?\A1\C0\A8\B9?a\A1\A4????\A8\A2D???\A6̦\CC
		//for (i = 0; i != num_groups; i++)
		//{
		//	pmx_doc_i = mxGetCell(pmx_trainss, i);
		//	num_words += mxGetNumberOfElements(pmx_doc_i);
		//}
		//trainss.reserve(num_words);
		//inds_groups.reserve(num_words);
		for (i = 0; i != num_groups; i++)
		{
			inds_items.push_back(vector<int>());
			vector<int> &inds_items_i = inds_items.back();
			//inds_items_i.reserve(num_words_i);
	/*		char txtNo[10];
			sprintf(txtNo, "%d", i+1);*/

			ostringstream s1;
			s1 << i+1;
			string s2 = s1.str();

			string txtname = trainss_file + "/doc_" + s2 + ".txt";
			//cout << txtname << endl;
			char * dir = &txtname[0];
			FILE *fileptr;
			fileptr = fopen(dir, "r");
			while (fscanf(fileptr, "%d", &word) != EOF)//?a????\A8\AE\A8\B2\A1\C1?????\A6̦\CC?\A8\A6\A8\B0??\80?\A8\A8?a\A6̨\A4\A8\BAy\A8\A2?
			{
				trainss.push_back(word-1);//word \A8\BA??\A8\AE1\A6\CC?25\A1\EA?o\A8\AE??\A8\AA3???\A8\BA?\A6̦\CC?\A8\BA\A1\C0o\A8\B0\A8\B0a?\A8\AE0\A8\AA3??
				inds_groups.push_back(i);
				inds_items_i.push_back(num_words++);
				//printf("num_words \A1\EAo%d", word - 1);
			}
			fclose(fileptr);
		}
		//cin >> j;
	}
}


#endif



/*
template<typename D> void Layer<D>::load_matlab_link(string& link_file, double _alpha_group)
{
	int i, j;
	alpha_group = _alpha_group;
	log_alpha_group = log(_alpha_group);
	if (link_file.empty())
	{
		// create document links and prior for ordinary lda //
		vector<int> group_candidates_i;
		vector<double> group_priors_i;
		vector<double> log_group_priors_i;
		group_candidates_i.push_back(0);
		group_priors_i.push_back(alpha_group);
		log_group_priors_i.push_back(log_alpha_group);
		group_candidates.push_back(group_candidates_i);
		group_priors.push_back(group_priors_i);
		log_group_priors.push_back(log_group_priors_i);
		for (i = 1; i != num_groups; i++)
		{
			group_candidates_i.push_back(i);
			group_candidates.push_back(group_candidates_i);
			group_priors_i.back() = 1.0;
			log_group_priors_i.back() = 0.0;
			group_priors_i.push_back(alpha_group);
			log_group_priors_i.push_back(log_alpha_group);
			group_priors.push_back(group_priors_i);
			log_group_priors.push_back(log_group_priors_i);
		}
	}
	else
	{
		MATFile *pmat = matOpen(link_file.c_str(), "r");
		mxArray *pmx_cand_links = matGetVariable(pmat, "cand_links");
		mxArray *pmx_log_priors= matGetVariable(pmat, "log_priors");
		mxArray *pmx_cands_i, *pmx_log_priors_i;
		double *pd_cands_i, *pd_log_priors_i;
		int num_cands_i, cnt = 0;


		// load data from .mat file //
	
		for (i = 0; i != num_groups; i++)
		{
			pmx_cands_i = mxGetCell(pmx_cand_links, i);
			pmx_log_priors_i = mxGetCell(pmx_log_priors, i);
			pd_cands_i = mxGetPr(pmx_cands_i);
			pd_log_priors_i = mxGetPr(pmx_log_priors_i);
			num_cands_i= mxGetNumberOfElements(pmx_cands_i);

			group_candidates.push_back(vector<int>());
			group_priors.push_back(vector<double>());
			log_group_priors.push_back(vector<double>());
			vector<int> &group_candidates_i = group_candidates.back();
			vector<double> &group_priors_i = group_priors.back();
			vector<double> &log_group_priors_i = log_group_priors.back();
		
			for (j = 0; j != num_cands_i - 1; j++)
			{
				group_candidates_i.push_back((int)(pd_cands_i[j]) - 1);
				log_group_priors_i.push_back(pd_log_priors_i[j]);
				group_priors_i.push_back(exp(pd_log_priors_i[j]));
			}
			group_candidates_i.push_back(i);
			log_group_priors_i.push_back(log_alpha_group);
			group_priors_i.push_back(alpha_group);
		}
		matClose(pmat);
	}
}
*/
template<typename D> void Layer<D>::load_txt_link(string& link_file, double _alpha_group)//20170821
{
	int i, j;
	alpha_group = _alpha_group;
	log_alpha_group = log(_alpha_group);
	if (link_file.empty())
	{
		/* create document links and prior for ordinary lda */
		vector<int> group_candidates_i;
		vector<double> group_priors_i;
		vector<double> log_group_priors_i;
		group_candidates_i.push_back(0);
		group_priors_i.push_back(alpha_group);
		log_group_priors_i.push_back(log_alpha_group);
		group_candidates.push_back(group_candidates_i);
		group_priors.push_back(group_priors_i);
		log_group_priors.push_back(log_group_priors_i);
		for (i = 1; i != num_groups; i++)
		{
			//group_candidates:0 |0 1|0 1 2|0 1 2 3|...
			//group_prior:	   a |1 a|1 1 a|1 1 1 a|...
			group_candidates_i.push_back(i);
			group_candidates.push_back(group_candidates_i);
			group_priors_i.back() = 1.0;
			log_group_priors_i.back() = 0.0;
			group_priors_i.push_back(alpha_group);
			log_group_priors_i.push_back(log_alpha_group);
			group_priors.push_back(group_priors_i);
			log_group_priors.push_back(log_group_priors_i);
		}
	}
	else
	{
		int  cnt = 0;
		for (i = 0; i != num_groups; i++)
		{
			//??\A8\AE\A8\B2???a??\A6̦\CC
			int num_cands_i, word;
			double logprior;
			group_candidates.push_back(vector<int>());
			group_priors.push_back(vector<double>());
			log_group_priors.push_back(vector<double>());
			vector<int> &group_candidates_i = group_candidates.back();
			vector<double> &group_priors_i = group_priors.back();
			vector<double> &log_group_priors_i = log_group_priors.back();

			ostringstream s1;
			s1 << i + 1;
			string s2 = s1.str();

			string linkname = link_file + "/cand_link" + s2 + ".txt";
			string logpriorname = link_file + "/log_prior" + s2 + ".txt";
			//cout << linkname << endl;
			char * dirlink = &linkname[0];
			char * dirlogprior = &logpriorname[0];
			FILE *fileptr1; 
			FILE *fileptr2;
			fileptr1 = fopen(dirlink, "r");
			//cout << "here";
			fileptr2 = fopen(dirlogprior, "r");
			fscanf(fileptr1, "[%d]", &num_cands_i);
			//cout << "num_cands_i" << num_cands_i;
			fscanf(fileptr2, "[%d]", &num_cands_i);
			//cout << "num_cands_i" << num_cands_i;
			for (j = 0; j != num_cands_i - 1; j++)
			{
				fscanf(fileptr1, "%d", &word);// != EOF;
				group_candidates_i.push_back(word - 1);//???\A8\B4\A8\AED\A1\C0\A8\BAo?????\A8\A2?\A8\B0???
				fscanf(fileptr2, "%d", &logprior);
				log_group_priors_i.push_back(logprior);
				group_priors_i.push_back(exp(logprior));
				//cout << word  << ";";
			}
			//while (fscanf(fileptr, "%d", &word) != EOF)//?a????\A8\AE\A8\B2\A1\C1?????\A6̦\CC?\A8\A6\A8\B0??\80?\A8\A8?a\A6̨\A4\A8\BAy\A8\A2?
			//{
			//	trainss.push_back(word - 1);//word \A8\BA??\A8\AE1\A6\CC?25\A1\EA?o\A8\AE??\A8\AA3???\A8\BA?\A6̦\CC?\A8\BA\A1\C0o\A8\B0\A8\B0a?\A8\AE0\A8\AA3??
			//	inds_groups.push_back(i);
			//	inds_items_i.push_back(num_words++);
			//	//printf("num_words \A1\EAo%d", word - 1);
			//}
			fclose(fileptr1);
			fclose(fileptr2);
			
			group_candidates_i.push_back(i);//\A8\A6\A8\A8??\A1\C1?\A8\A2??\A8\AE\A6\CC??\A6̨\BA?alpha 1
			log_group_priors_i.push_back(log_alpha_group);
			group_priors_i.push_back(alpha_group);
			///cout << endl;
		}
	

	}
}

template<typename D> void Layer<D>::initialize_link(int num_groups, int num_init_cls)
{
	int i;
	int tot_num_words = trainss.size();
	
	customers.assign(tot_num_words, 0);
	tables.assign(tot_num_words, 0);
	if (num_groups == 1)
	{
		inds_groups.assign(tot_num_words, 0);
		inds_items.push_back(vector<int>());
		if (child)
		{
			collect_customers();
		}
		else
		{
			inds_items.back().reserve(tot_num_words);
			for (i = 0; i != tot_num_words; i++)
			{
				inds_items.back().push_back(i);
			}
		}
	}
	
	uni_tables.assign(num_groups, list<int>());
	pos_uni_tables.assign(tot_num_words, list<int>::iterator());

	if (num_init_cls == tot_num_words)
	{
		for (i = 0; i != inds_items.size(); i++)
		{
			list<int> &uni_tables_i = uni_tables.at(i);
			vector<int> &inds_items_i = inds_items.at(i);
			vector<int>::iterator it_i;
			int idx_j, idx_0 = inds_items_i.front();
			for (it_i = inds_items_i.begin(); it_i != inds_items_i.end(); it_i++)
			{
				idx_j = *it_i;
				customers.at(idx_j) = idx_j;
				tables.at(idx_j) = idx_j;
				uni_tables_i.push_back(idx_j);
				pos_uni_tables.at(idx_j) = --uni_tables_i.end();
			}
		}
	}
	else
	{
		for (i = 0; i != inds_items.size(); i++)
		{
			list<int> &uni_tables_i = uni_tables.at(i);
			vector<int> &inds_items_i = inds_items.at(i);
			vector<int>::iterator it_i;
			int idx_j, idx_0 = inds_items_i.front();
			for (it_i = inds_items_i.begin(); it_i != inds_items_i.end(); it_i++)
			{
				idx_j = *it_i;
				customers.at(idx_j) = idx_0;
				tables.at(idx_j) = idx_0;
			}
			uni_tables_i.push_back(idx_0);
			pos_uni_tables.at(idx_0) = --uni_tables_i.end();
		}
	}
}

template<typename D> void Layer<D>::collect_customers()
{
#ifdef PRINT_FUNC_NAME
	cout << "collect_customers()" << endl;
#endif
	vector< vector<int> >::iterator it_item_i;
	vector<int>::iterator it_item_j;
	vector< list<int> >::iterator it_tab_i;
	list<int>::iterator it_tab_j;
	if (child != NULL)
	{
		for (it_item_i = inds_items.begin(); it_item_i != inds_items.end(); it_item_i++)
		{
			it_item_i->clear();
		}

		vector< list<int> > &uni_tables_child = child->uni_tables;
		for (it_tab_i = uni_tables_child.begin(); it_tab_i != uni_tables_child.end(); it_tab_i++)
		{
			for (it_tab_j = it_tab_i->begin(); it_tab_j != it_tab_i->end(); it_tab_j++)
			{
				int idx_table = *it_tab_j;
				int idx_group = inds_groups.at(idx_table);
				inds_items.at(idx_group).push_back(idx_table);
			}
		}
	}
}

template<typename D> void Layer<D>::get_candidates()
{
#ifdef PRINT_FUNC_NAME
	cout << "get_candidates()" << endl;
#endif
	if (child == NULL)
	{
		int i = inds_groups.at(cur_item);
		vector<int> &inds_items_cur = inds_items.at(i);
		int j = cur_item - inds_items_cur.front();
		if (item_candidates.empty())
		{
			//item_cands_cur.clear();
			//log_item_priors_cur.clear();
			//if (j != 0)
			//{
				//item_cands_cur.push_back(cur_item-1);
				//log_item_priors_cur.push_back(0.0);
			//}
			//item_cands_cur.push_back(cur_item);
			//log_item_priors_cur.push_back(log_alpha_item);

			vector<int>::iterator start = inds_items_cur.begin();
			vector<int>::iterator end = inds_items_cur.begin() + j + 1;
			item_cands_cur.assign(start, end);
			//item_priors_cur.assign(item_cands_cur.size(), 1.0);
			log_item_priors_cur.assign(item_cands_cur.size(), 0.0);
			//item_priors_cur.back() = alpha_item;
			log_item_priors_cur.back() = log_alpha_item;
		}
		else
		{
			item_cands_cur = item_candidates.at(i).at(j);
			//item_priors_cur = item_priors.at(i).at(j);
			log_item_priors_cur = log_item_priors.at(i).at(j);
		}
	}
	else
	{
		item_cands_cur.clear();
		item_priors_cur.clear();
		log_item_priors_cur.clear();
		int idx_table_child  = cur_item;
		int idx_group_child = child->inds_groups.at(idx_table_child);
		vector<int> &group_candidates_i = child->group_candidates.at(idx_group_child);
		vector<double> &group_priors_i = child->group_priors.at(idx_group_child);
		vector<double> &log_group_priors_i = child->log_group_priors.at(idx_group_child);
		vector<int>::iterator it_c = group_candidates_i.begin();
		vector<double>::iterator it_p = group_priors_i.begin();
		vector<double>::iterator it_log_p = log_group_priors_i.begin();
		for (; it_c != group_candidates_i.end()-1; it_c++, it_p++, it_log_p++)
		{
			list<int> &uni_tables_i = child->uni_tables.at(*it_c);
			list<int>::iterator it_t = uni_tables_i.begin();
			for (; it_t != uni_tables_i.end(); it_t++)
			{
				item_cands_cur.push_back(*it_t);
			}
			item_priors_cur.insert(item_priors_cur.end(), uni_tables_i.size(), *it_p);
			log_item_priors_cur.insert(log_item_priors_cur.end(), uni_tables_i.size(), *it_log_p);
		}
		list<int> &uni_tables_i = child->uni_tables.at(idx_group_child);
		list<int>::iterator it_t = uni_tables_i.begin();
		while (it_t != uni_tables_i.end() && cur_item > *it_t)
		{
			item_cands_cur.push_back(*it_t);
			item_priors_cur.push_back(1.0);
			log_item_priors_cur.push_back(0.0);
			it_t++;
		}
		item_cands_cur.push_back(idx_table_child);
		item_priors_cur.push_back(alpha_item);
		log_item_priors_cur.push_back(log_alpha_item);
	}
}

template<class D> void Layer<D>::check_link_status()
{
	old_customer_cur = customers.at(cur_item);
	old_table_cur = tables.at(old_customer_cur);
	is_self_linked = (old_customer_cur == cur_item) ? true : false;
	if (is_self_linked)
	{
		if (parent)
		{
			parent->check_link_status();
		}
		else
		{
			collect_connections();
		}
	}
	else
	{
		collect_connections();
	}
}

template<typename D> inline void Layer<D>::delete_table(int _old_table)
{
	uni_tables.at(idx_group_cur).erase(pos_uni_tables.at(_old_table));
}

template<typename D> void Layer<D>::add_table()
{
	list<int> &uni_tables_cur = uni_tables.at(idx_group_cur);
	list<int>::iterator it = uni_tables_cur.begin();
	while (it != uni_tables_cur.end() && cur_item > *it)
	{
		it++;
	}
	pos_uni_tables.at(cur_item) = uni_tables_cur.insert(it, cur_item);
}

template<typename D> inline void Layer<D>::change_table(int _new_table)
{
	for (vector<int>::const_iterator it = connection_start+1; it != connection_end; it++)
	{
		tables.at(*it) = _new_table;
	}
}

template<typename D> void Layer<D>::change_customer(int _new_customer)
{
	vector<int> &links_cur = links.at(cur_item);
	for (vector<int>::iterator it = links_cur.begin(); it != links_cur.end(); it++)
	{
		customers.at(*it) = _new_customer;
	}
}

template<typename D> void Layer<D>::merge_customers()
{
	if (is_self_linked)
	{
		idx_group_cur = inds_groups.at(cur_item);
		delete_table(cur_item);
	}
	change_customer(new_customer_cur);
	new_table_cur = tables.at(new_customer_cur);
	change_table(new_table_cur);
	if (is_self_linked)
	{
		if (parent)
		{
			parent->new_customer_cur = new_table_cur;
			parent->merge_customers();
		}
		else
		{
			base.del_class(pos_classqq.at(cur_item));
		}
	}
}

template<typename D> void Layer<D>::update_link()
{
	customers.at(cur_item) = new_customer_cur;
	tables.at(cur_item) = new_table_cur;
	change_table(new_table_cur);
}

template<typename D> int Layer<D>::get_cluster(int _cur_item)
{
	int cluster_cur = _cur_item;
	Layer<D> *layer = this;
	do
	{
		cluster_cur = layer->tables.at(cluster_cur);
	}
	while ( layer = layer->parent );
	return cluster_cur;
}

template<typename D> void Layer<D>::collect_clusters()
{
#ifdef PRINT_FUNC_NAME
	cout << "collect_clusters()" << endl;
#endif
	cls_cands_cur.clear();
	uni_cls_cands_cur.clear();
	
	vector<int>::iterator it, end = item_cands_cur.end() - 1;
	int cluster_i;
	vector<bool> flag(trainss.size(), false);
	for (it = item_cands_cur.begin(); it != end; it++)
	{
		cluster_i = get_cluster(*it);
		cls_cands_cur.push_back(cluster_i);
		if (!flag.at(cluster_i))
		{
			uni_cls_cands_cur.push_back(cluster_i);
			flag.at(cluster_i) = true;
		}
	}
}

template<typename D> void Layer<D>::collect_connections()
{
	it_stat_cur = stats.at(old_tables.at(cur_item)).begin() + inds_start.at(cur_item);
	for (Layer<D>* layer = this; layer != cur_layer->child; layer = layer->child)
	{
		layer->connection_start = layer->trees.at(layer->old_tables.at(cur_item)).begin() + layer->inds_start.at(cur_item);
		layer->connection_end = layer->trees.at(layer->old_tables.at(cur_item)).begin() + layer->inds_end.at(cur_item) + 1;
	}
}

template<typename D> inline void Layer<D>::compute_marg_lik(int c)
{
	if (!is_computed.at(c))
	{
		log_pred_liks.at(c) = base.marg_likelihood(*pos_classqq.at(c), *it_stat_cur);
		pred_liks.at(c) = exp(log_pred_liks.at(c));
		is_computed.at(c) = true;
	}
}

template<typename D> void Layer<D>::compute_marg_liks()
{
#ifdef PRINT_FUNC_NAME
	cout << "compute_marg_liks()" << endl;
#endif
	for_each(uni_cls_cands_cur.begin(), uni_cls_cands_cur.end(), bind1st(mem_fun(&Layer<D>::compute_marg_lik), this));
}

template<typename D> double Layer<D>::compute_log_self_link_lik()
{
	get_candidates();
	collect_clusters();
	compute_marg_liks();


	if (parent)
	{
		log_self_link_lik = parent->compute_log_self_link_lik();
	}
	else
	{
		base.reset_class(qq_temp);
		log_self_link_lik = base.marg_likelihood(qq_temp, *it_stat_cur);
	}

	double child_self_link_lik = 0.0;
	double sum_priors = 0.0;
	log_probs_sampling.assign(cls_cands_cur.size(), 0.0);
	
	vector<int>::iterator it_c = cls_cands_cur.begin();
	vector<double>::iterator it_p = item_priors_cur.begin();
	vector<double>::iterator it_log_p = log_item_priors_cur.begin();
	vector<double>::iterator it_prob = log_probs_sampling.begin();
	double log_prob_i;
	for (; it_c != cls_cands_cur.end(); it_c++, it_p++, it_log_p++, it_prob++)
	{
		*it_prob = (*it_log_p) + log_pred_liks.at(*it_c);
		if (*it_prob > max_log_prob)
		{
			max_log_prob = *it_prob;
		}
		child_self_link_lik += pred_liks.at(*it_c) * (*it_p);
		sum_priors += *it_p;
	}

	log_probs_sampling.push_back(log_alpha_item + log_self_link_lik);
	if (log_probs_sampling.back() > max_log_prob)
	{
		max_log_prob = log_probs_sampling.back();
	}
	child_self_link_lik += exp(log_probs_sampling.back());
	sum_priors += alpha_item;
	child_self_link_lik /= sum_priors;
	return log(child_self_link_lik);
}


template<typename D> void Layer<D>::compute_log_probs_sampling()
{
	log_probs_sampling.clear();
	max_log_prob = -DBL_MAX;
	vector<int>::iterator it_c = cls_cands_cur.begin();
	vector<double>::iterator it_log_p = log_item_priors_cur.begin();
	double log_prob_i;
	for (; it_c != cls_cands_cur.end(); it_c++, it_log_p++)
	{
		log_prob_i = (*it_log_p) + log_pred_liks.at(*it_c);
		log_probs_sampling.push_back( log_prob_i );
		if (log_prob_i > max_log_prob)
		{
			max_log_prob = log_prob_i;
		}
	}
	log_prob_i = log_alpha_item + log_self_link_lik;
	log_probs_sampling.push_back( log_prob_i );
	if (log_prob_i > max_log_prob)
	{
		max_log_prob = log_prob_i;
	}
}

template<typename D> void Layer<D>::sample_customer()
{
#ifdef PRINT_FUNC_NAME
	cout << "sample_customer()" << endl;
#endif

	double sum = 0.0;
	for (vector<double>::iterator it_p = log_probs_sampling.begin(); it_p != log_probs_sampling.end(); it_p++)
	{
		*it_p = exp(*it_p - max_log_prob);
		sum += *it_p;
	}
	log_probs_sampling.push_back(sum);

	int idx_ci = rand_mult_1(log_probs_sampling);
	new_customer_cur = item_cands_cur.at(idx_ci);
}
	
template<typename D> void Layer<D>::sample_new_customer()
{
	sample_customer();
	customers.at(cur_item) = new_customer_cur;
	if (new_customer_cur != cur_item)
	{
		new_table_cur = tables.at(new_customer_cur);
		tables.at(cur_item) = new_table_cur;
		new_cls_cur = get_cluster(new_customer_cur);
		base.add_data(*pos_classqq.at(new_cls_cur), *it_stat_cur);
	}
	else
	{
		new_table_cur = cur_item;
		tables.at(cur_item) = cur_item;
		idx_group_cur = inds_groups.at(cur_item);
		add_table();
		if (parent)
		{
			parent->sample_new_customer();
		}
		else
		{
			pos_classqq.at(cur_item) = base.add_class();
			base.add_data(*pos_classqq.at(cur_item), *it_stat_cur);
		}
	}
}

template<typename D> void Layer<D>::sample_for_single()
{
	int step = 0;

#ifdef MY_DEBUG
	gettimeofday(&tv_begin, NULL);
#endif

	idx_group_cur = inds_groups.at(cur_item);
	get_candidates();
	if (item_cands_cur.size() == 1)
	{
		return;
	}

#ifdef MY_DEBUG
	gettimeofday(&tv_end, NULL);
	timer.accumulate_time(step++, tv_begin, tv_end);
#endif
	
	


#ifdef MY_DEBUG
	gettimeofday(&tv_begin, NULL);
#endif

	collect_clusters();

#ifdef MY_DEBUG
	gettimeofday(&tv_end, NULL);
	timer.accumulate_time(step++, tv_begin, tv_end);
#endif




#ifdef MY_DEBUG
	gettimeofday(&tv_begin, NULL);
#endif

	old_customer_cur = customers.at(cur_item);
	old_table_cur = tables.at(old_customer_cur);
	is_self_linked = (old_customer_cur == cur_item) ? true : false;
	if (is_self_linked)
	{
		if (parent)
		{
			parent->check_link_status();
		}
		else
		{
			collect_connections();
		}
	}
	else
	{
		collect_connections();
	}

#ifdef MY_DEBUG
	gettimeofday(&tv_end, NULL);
	timer.accumulate_time(step++, tv_begin, tv_end);
#endif




#ifdef MY_DEBUG
	gettimeofday(&tv_begin, NULL);
#endif

	old_cls_cur = get_cluster(cur_item);
	base.del_data(*pos_classqq.at(old_cls_cur), *it_stat_cur);

#ifdef MY_DEBUG
	gettimeofday(&tv_end, NULL);
	timer.accumulate_time(step++, tv_begin, tv_end);
#endif




#ifdef MY_DEBUG
	gettimeofday(&tv_begin, NULL);
#endif

	is_computed.assign(trainss.size(), false);
	compute_marg_liks();

#ifdef MY_DEBUG
	gettimeofday(&tv_end, NULL);
	timer.accumulate_time(step++, tv_begin, tv_end);
#endif




#ifdef MY_DEBUG
	gettimeofday(&tv_begin, NULL);
#endif

	if (parent)
	{
		if (is_self_linked)
		{
			log_self_link_lik = base.marg_likelihood(*pos_classqq.at(old_cls_cur), *it_stat_cur);
		}
		else
		{
			log_self_link_lik = parent->compute_log_self_link_lik();
		}
	}
	else
	{
		base.reset_class(qq_temp);
		log_self_link_lik = base.marg_likelihood(qq_temp, *it_stat_cur);
	}

#ifdef MY_DEBUG
	gettimeofday(&tv_end, NULL);
	timer.accumulate_time(step++, tv_begin, tv_end);
#endif




#ifdef MY_DEBUG
	gettimeofday(&tv_begin, NULL);
#endif

	compute_log_probs_sampling();
	sample_customer();

#ifdef MY_DEBUG
	gettimeofday(&tv_end, NULL);
	timer.accumulate_time(step++, tv_begin, tv_end);
#endif




#ifdef MY_DEBUG
	gettimeofday(&tv_begin, NULL);
#endif

	if (new_customer_cur != old_customer_cur)
	{
		if (cur_item != new_customer_cur)
		{
			new_table_cur = tables.at(new_customer_cur);
			update_link();
			new_cls_cur = get_cluster(new_customer_cur);
			base.add_data(*pos_classqq.at(new_cls_cur), *it_stat_cur);
			if (is_self_linked)
			{
				delete_table(cur_item);
				if (parent)
				{
					parent->new_customer_cur = new_table_cur;
					parent->merge_customers();
				}
				else
				{
					base.del_class(pos_classqq.at(cur_item));
				}
			}
		}
		else
		{
			new_table_cur = new_customer_cur;
			update_link();
			add_table();
			if (parent)
			{
				parent->sample_new_customer();
			}
			else
			{
				pos_classqq.at(cur_item) = base.add_class();
				base.add_data(*pos_classqq.at(cur_item), *it_stat_cur);
			}
		}
	}
	else
	{
		base.add_data(*pos_classqq.at(old_cls_cur), *it_stat_cur);
	}

#ifdef MY_DEBUG
	gettimeofday(&tv_end, NULL);
	timer.accumulate_time(step++, tv_begin, tv_end);
#endif
}

template<typename D> void Layer<D>::run_sampler()
{
	cur_layer = this;
	if (!child)
	{
		for (cur_item = 0; cur_item != trainss.size(); cur_item++)
		{
#ifdef MY_DEBUG
			//if (iter > 0)
			//cout << "iter " << iter << " layer " << cur_layer_no << " sampling " << cur_item << endl;
			//if (iter >= 0 && cur_layer_no == 0 && cur_item >= 1)
			//{
				//int a = 0;
			//}
#endif
			sample_for_single();
		}
	}
	else
	{
		vector<int>& uni_tables_vec_child = child->uni_tables_vec;
		for (vector<int>::iterator it = uni_tables_vec_child.begin(); it != uni_tables_vec_child.end(); it++)
		{
			cur_item = *it;
#ifdef MY_DEBUG
			//if (iter >= 1)
			//cout << "iter " << iter << " layer " << cur_layer_no << " sampling " << cur_item << endl;
			//if (iter >= 1 && cur_layer_no == 1 && cur_item >= 0)
			//{
			//	int a = 0;
			//}
#endif
			sample_for_single();
		}
	}
}
/*
template<typename D> void Layer<D>::traverse_single_table(int idx_table)
{
cout<<"the current idx table is "<<idx_table;
	vector<int>& tree_i = trees.at(idx_table);
	vector<int>& order_i = orders.at(idx_table);
	vector<STAT>& stat_i = stats.at(idx_table);
	vector<int> to_visit, to_visit_father, father_i;
	int cnt = 0;
	tree_i.push_back(idx_table);
	father_i.push_back(-1);
	stat_i.push_back(STAT());
	inds_start.at(idx_table) = cnt++;
	vector<int>& links_t = links.at(idx_table);
	vector<int>::iterator p = links_t.begin();
	if (p != links_t.end())
	{
		to_visit.push_back(*p);
		to_visit_father.push_back(idx_table);
		p++;
	}
	else
	{
		inds_end.at(idx_table) = 0;
		child ? 
			(stat_i.front() = child->stats.at(idx_table).front()) : 
			(stat_i.front().init(trainss.at(idx_table), base.get_eta()));
		order_i.push_back(0);
		return;
	}
	for (; p != links_t.end(); p++)
	{
		to_visit.push_back(*p);
		to_visit_father.push_back(-1);
	}
cout<<"done the traverse link part "<<inds_groups.at(idx_table)<<endl;
	int curr;
	while(!to_visit.empty())
	{
		curr = to_visit.back();
		inds_start.at(curr) = cnt++;
		tree_i.push_back(curr);
		stat_i.push_back(STAT());
		father_i.push_back(to_visit_father.back());
		to_visit.pop_back();
		to_visit_father.pop_back();
		vector<int> & links_curr = links.at(curr);
		if (!links_curr.empty())
		{
			p = links_curr.begin();
			to_visit.push_back(*p);
			to_visit_father.push_back(curr);
			for (p++; p != links_curr.end(); p++)
			{
				to_visit.push_back(*p);
				to_visit_father.push_back(-1);
			}
		}
		else
		{
			inds_end.at(curr) = inds_start.at(curr);

			child ? 
				(stat_i.at(inds_start.at(curr)).init(child->stats.at(curr).front(), base.get_eta())) : 
				stat_i.at(inds_start.at(curr)).init(trainss.at(curr), base.get_eta());
			order_i.push_back(inds_start.at(curr));
			int f = father_i.at(inds_start.at(curr));
			while (f >= 0)
			{
				inds_end.at(f) = inds_end.at(curr);
				child ? 
					(stat_i.at(inds_start.at(f)).init(child->stats.at(f).front(), base.get_eta())) : 
					stat_i.at(inds_start.at(f)).init(trainss.at(f), base.get_eta());
				order_i.push_back(inds_start.at(f));
				for (p = links.at(f).begin(); p != links.at(f).end(); p++)
				{
					stat_i.at(inds_start.at(f)).update(stat_i.at(inds_start.at(*p)));
					stat_i.at(inds_start.at(*p)).clear_inds();
				}
				f = father_i.at(inds_start.at(f));
			}
		}
	}
	stat_i.front().clear_inds();
}*/
template<typename D> void Layer<D>::traverse_single_table(int idx_table)
{//输入是餐桌的标号，对餐桌的树及其子树进行梳理存储在tree.at(idx_table)，并统计其观测值存在相应的stats中，
	vector<int>& tree_i = trees.at(idx_table);//
	vector<int>& order_i = orders.at(idx_table);
	vector<STAT>& stat_i = stats.at(idx_table);
	vector<int> to_visit, to_visit_father, father_i;
	int cnt = 0;
	tree_i.push_back(idx_table);//起始元素是这个餐桌的标号点
	father_i.push_back(-1);//根节点处标记为-1 应该是没有父节点的意思
	stat_i.push_back(STAT());
	inds_start.at(idx_table) = cnt++;//为根节点处的状态夹1
	vector<int>& links_t = links.at(idx_table);//在一个餐桌标号处的link值
	vector<int>::iterator p = links_t.begin();
	if (p != links_t.end())//这里并非循环只是判断是否为空
	{
		to_visit.push_back(*p);//to_visit 装填的是下一个要访问的位置
		to_visit_father.push_back(idx_table);//装填的是本次所在的节点
		p++;
	}
	else
	{//如果这个餐桌的link值是空的 
		inds_end.at(idx_table) = 0;
		child ?//child 为true计算expr1；为false计算expr2
			(stat_i.front() = child->stats.at(idx_table).front()) : //如果有子节点
			(stat_i.front().init(trainss.at(idx_table), base.get_eta()));//如果是最底层,初始化idx_table那一点的uni_ss；uni_qq;的值

		order_i.push_back(0);
		return;
	}

	for (; p != links_t.end(); p++)
	{
		to_visit.push_back(*p);//指向下一个值
		to_visit_father.push_back(-1);//父节点已经保存过了，这里都标记成-1
	}
	int curr;
	while (!to_visit.empty())//如果经过上面的折腾之后to_visit不是空的，则？？
	{
		curr = to_visit.back();//从最后一个开始
		inds_start.at(curr) = cnt++;//这个cnt是跟着上面的来的
		tree_i.push_back(curr);
		stat_i.push_back(STAT());
		father_i.push_back(to_visit_father.back());
		to_visit.pop_back();
		to_visit_father.pop_back();//把tovisit和tovisitfater的值给tree_i ,father_i之后释放
		vector<int> & links_curr = links.at(curr);
		if (!links_curr.empty())
		{//如果在curr点的link不是空的
			p = links_curr.begin();
			to_visit.push_back(*p);
			to_visit_father.push_back(curr);
			for (p++; p != links_curr.end(); p++)
			{
				to_visit.push_back(*p);
				to_visit_father.push_back(-1);
			}
		}
		else
		{//如果该点的links是空的

			inds_end.at(curr) = inds_start.at(curr);
			child ?
				(stat_i.at(inds_start.at(curr)).init(child->stats.at(curr).front(), base.get_eta())) :
				stat_i.at(inds_start.at(curr)).init(trainss.at(curr), base.get_eta());
			order_i.push_back(inds_start.at(curr));//表明了这个

			int f = father_i.at(inds_start.at(curr));
			while (f >= 0)//有大于0表示其子节点已经算完了
			{
				inds_end.at(f) = inds_end.at(curr);//那么该节点所包含的子节点就应该到这个位置结束了
				child ?
					(stat_i.at(inds_start.at(f)).init(child->stats.at(f).front(), base.get_eta())) :
					stat_i.at(inds_start.at(f)).init(trainss.at(f), base.get_eta());
				order_i.push_back(inds_start.at(f));
				for (p = links.at(f).begin(); p != links.at(f).end(); p++)
				{
					stat_i.at(inds_start.at(f)).update(stat_i.at(inds_start.at(*p)));//改变了stat中的inds的值
					stat_i.at(inds_start.at(*p)).clear_inds();

				}
				f = father_i.at(inds_start.at(f));//继续向上回溯
			}
		}
	}
	stat_i.front().clear_inds();
}
template<typename D> void Layer<D>::traverse_links()
{
	uni_tables_vec.clear();
	for (auto it_i = uni_tables.begin(); it_i != uni_tables.end(); it_i++)
	{
		for (auto it_j = it_i->begin(); it_j != it_i->end(); it_j++)
		{
			uni_tables_vec.push_back(*it_j);
		}
	}
	
	links.assign(trainss.size(), vector<int>());
	if (child)
	{
		for (auto it = child->uni_tables_vec.begin(); it != child->uni_tables_vec.end(); it++)
		{
			int cst = customers.at(*it);
			if (cst != *it)
			{
				links.at(cst).push_back(*it);
			}
		}
	}
	else
	{
		int i = 0;
		for (auto it = customers.begin(); it != customers.end(); it++, i++)
		{
			if (*it != i)
			{
				links.at(*it).push_back(i);
			}
		}
	}

	old_tables = tables;
	trees.assign(trainss.size(), vector<int>());
	orders.assign(trainss.size(), vector<int>());
	stats.assign(trainss.size(), vector<STAT>());
	inds_start.assign(trainss.size(), -1);
	inds_end.assign(trainss.size(), -1);

	__gnu_parallel::for_each(uni_tables_vec.begin(), uni_tables_vec.end(), bind1st(mem_fun(&Layer<D>::traverse_single_table), this));
/*		for (int i = 0; i < uni_tables_vec.size(); i++)
		{
//cout<<"traverse uni_tables_vec.at("<<i<<")";
			this->traverse_single_table(uni_tables_vec.at(i));
//cout<<" is done"<<endl;
		}
*/
//cout<<"we done this travers once. "<<endl;
}

#ifdef TRI_MULT_DIST
template<typename D> int Layer<D>::sample_ss(vector<int>& qq, vector<double>& eta, int w)
{
	qq.at(w)--;
	qq.back()--;
	vector<double> weights = eta;
	for (int i = 0; i != weights.size(); i++)
	{
		weights.at(i) += (double)qq.at(i);
	}
	int new_w = rand_mult_1(weights);
	qq.at(new_w)++;
	qq.back()++;
	return new_w;
}

template<typename D> void Layer<D>::sample_source_sink_c(int t, int c)
{
	if (child)
	{
		for (auto it = trees.at(t).begin(); it != trees.at(t).end(); it++)
		{
			child->sample_source_sink_c(*it, c);
		}
	}
	else
	{
		QQ& qq = *pos_classqq.at(c);
		for (auto it = trees.at(t).begin(); it != trees.at(t).end(); it++)
		{
			SS& ss = trainss.at(*it);

			if (ss.gibbs_source)
			{
				ss.source = sample_ss(qq.qq_source, base.get_eta().eta_source, ss.source);
			}

			if (ss.gibbs_sink)
			{
				ss.sink = sample_ss(qq.qq_sink, base.get_eta().eta_sink, ss.sink);
			}
		}
	}
}

template<typename D> void Layer<D>::sample_source_sink()
{
	__gnu_parallel::for_each(top->uni_tables_vec.begin(), top->uni_tables_vec.end(), [](int c){ top->sample_source_sink_c(c, c); });
}

template<typename D> void Layer<D>::update_ss_stats_c(int idx_table)
{
	vector<int>& tree_i = trees.at(idx_table);
	vector<int>& order_i = orders.at(idx_table);
	vector<STAT>& stat_i = stats.at(idx_table);
	vector<int>::iterator it_o;
	int curr;
	for (it_o = order_i.begin(); it_o != order_i.end(); it_o++)
	{
		curr = tree_i.at(*it_o);
#ifdef MY_DEBUG
		if (idx_table == 1 && curr == 16235)
		{
			int a = 0;
		}
#endif
		child ? stat_i.at(*it_o).copy_ss(child->stats.at(curr).front()) : stat_i.at(*it_o).init_ss(trainss.at(curr), base.get_eta());
		for (auto p = links.at(curr).begin(); p != links.at(curr).end(); p++)
		{
			stat_i.at(*it_o).update_ss(stat_i.at(inds_start.at(*p)));
			stat_i.at(inds_start.at(*p)).clear_inds();
		}
#ifdef MY_DEBUG
		if (!stat_i.at(*it_o).check_stat())
		{
			cout << "idx_table = " << idx_table << endl;
			cout << "curr = " << curr << endl;
			int a = 0;
		}
#endif
	}
}

template<typename D> void Layer<D>::update_ss_stats()
{
	__gnu_parallel::for_each(uni_tables_vec.begin(), uni_tables_vec.end(), bind1st(mem_fun(&Layer<D>::update_ss_stats_c), this));
}

template<typename D> void Layer<D>::label_instances()
{
	for (int i = 0; i != bottom->num_groups; i++)
	{
		vector<int> topics;
		vector<int> topic_stat;
		vector<int> pos(trainss.size(), -1);
		vector<int> &inds_items_i = bottom->inds_items.at(i);
		for (int j = 0; j != inds_items_i.size(); j++)
		{
			int c = bottom->get_cluster(inds_items_i.at(j));
			if (pos.at(c) < 0)
			{
				pos.at(c) = topics.size();
				topics.push_back(c);
				topic_stat.push_back(1);
			}
			else
			{
				topic_stat.at(pos.at(c))++;
			}
		}
		int max_stat = 0, idx = 0;
		for (int i = 0; i != topic_stat.size(); i++)
		{
			if (topic_stat.at(i) > max_stat)
			{
				max_stat = topic_stat.at(i);
				idx = i;
			}
		}
		labels.at(i) = topics.at(idx);
	}
}

template<typename D> void Layer<D>::save_labels(string& save_dir, int iter)
{
	if (save_dir.back() != '/')
	{
		save_dir += '/';
	}
	ostringstream file_name_stream;
	file_name_stream << save_dir << "label" << iter;
	string label_file_name = file_name_stream.str() + ".txt";
	ofstream output_stream(label_file_name.c_str());
	cout << "saving trajectory labels at iteration " << iter << " ..." << endl;
	for (int i = 0; i != bottom->num_groups; i++)
	{
		output_stream << labels.at(i) << endl;
	}
	output_stream.close();
}

template<typename D> void Layer<D>::save_topic_labels(string& save_dir, int iter)
{
	if (save_dir.back() != '/')
	{
		save_dir += '/';
	}
	ostringstream file_name_stream;
	file_name_stream << save_dir << "topic_label" << iter;
	string label_file_name = file_name_stream.str() + ".txt";
	ofstream output_stream(label_file_name.c_str());
	cout << "saving topic labels for words at iteration " << iter << " ..." << endl;
	for (int i = 0; i != trainss.size(); i++)
	{
		output_stream << bottom->get_cluster(i) << endl;
	}
	output_stream.close();
}
#endif

