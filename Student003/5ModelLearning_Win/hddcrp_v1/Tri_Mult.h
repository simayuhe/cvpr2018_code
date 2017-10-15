#pragma once
#include "Multinomial.h"
#include <vector>
#include <list>
#include <iostream>
#include <fstream>
#include <sstream>
using namespace std;


class SS_Tri_Mult
{
public:
	int word;
	int source;
	int sink;
	bool gibbs_source;
	bool gibbs_sink;

	SS_Tri_Mult():word(0), source(0), sink(0), gibbs_source(false), gibbs_sink(false){}
};

class HH_Tri_Mult
{
public:
	vector<double> eta_word;
	vector<double> eta_source;
	vector<double> eta_sink;
	HH_Tri_Mult(){};
	~HH_Tri_Mult(){};
	HH_Tri_Mult(int voc_size_word, double eta_i_word, 
			int voc_size_source, double eta_i_source, 
			int voc_size_sink, double eta_i_sink):
		eta_word(voc_size_word, eta_i_word), 
		eta_source(voc_size_source, eta_i_source),
		eta_sink(voc_size_sink, eta_i_sink){}
};

class QQ_Tri_Mult
{
public:
	vector<int> qq_word;
	vector<int> qq_source;
	vector<int> qq_sink;
	QQ_Tri_Mult(){};
	~QQ_Tri_Mult(){};
	QQ_Tri_Mult(HH_Tri_Mult& _eta):
		qq_word(_eta.eta_word.size(), 0), qq_source(_eta.eta_source.size(), 0), qq_sink(_eta.eta_sink.size(), 0) {}
};

class Stat_Tri_Mult
{
public:
	Stat_Mult stat_word;
	Stat_Mult stat_source;
	Stat_Mult stat_sink;
	int tot;
	Stat_Tri_Mult():tot(0){}
	~Stat_Tri_Mult(){}
	Stat_Tri_Mult& init(SS_Tri_Mult& ss, HH_Tri_Mult& _eta);
	Stat_Tri_Mult& init(Stat_Tri_Mult& stat, HH_Tri_Mult& _eta);
	Stat_Tri_Mult& update(Stat_Tri_Mult& stat);
	Stat_Tri_Mult& init_ss(SS_Tri_Mult& ss, HH_Tri_Mult& _eta);
	Stat_Tri_Mult& copy_ss(Stat_Tri_Mult& stat);
	Stat_Tri_Mult& update_ss(Stat_Tri_Mult& stat);
	void clear_inds();
	bool check_stat();
};

class Log_Vals
{
public:
	vector< vector<double> > log_vals_word;
	vector< vector<double> > log_vals_source;
	vector< vector<double> > log_vals_sink;
	Log_Vals(){}
	~Log_Vals(){}
};

class Tri_Mult
{
public:
	Tri_Mult(void){}
	~Tri_Mult(void){}
	void initialize_eta(HH_Tri_Mult& _eta);
	list< QQ_Tri_Mult >& get_classqq(){return classqq;}
	HH_Tri_Mult& get_eta(){return eta;}
	double marg_likelihood(QQ_Tri_Mult& qq, Stat_Tri_Mult& stat);
	void add_data(QQ_Tri_Mult& qq, SS_Tri_Mult& ss);
	void add_data(QQ_Tri_Mult& qq, Stat_Tri_Mult& stat);
	void del_data(QQ_Tri_Mult& qq, Stat_Tri_Mult& stat);
	list< QQ_Tri_Mult >::iterator add_class();
	void del_class(list< QQ_Tri_Mult >::iterator it);
	void output(string& save_dir, int iter);
	void reset_class(QQ_Tri_Mult& qq);
	void init_log_pos_vals(int tot_num_words);
	static bool check_qq(QQ_Tri_Mult& qq);
	
private:
	HH_Tri_Mult eta;
	list< QQ_Tri_Mult > classqq;
	Log_Vals log_vals;
};

