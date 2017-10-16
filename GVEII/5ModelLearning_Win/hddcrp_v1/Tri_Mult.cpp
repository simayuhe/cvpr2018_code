#include "StdAfx.h"
#include "Tri_Mult.h"
#include <math.h>


Stat_Tri_Mult& Stat_Tri_Mult::init_ss(SS_Tri_Mult& ss, HH_Tri_Mult& _eta)
{
	stat_source.init(ss.source, _eta.eta_source);
	stat_sink.init(ss.sink, _eta.eta_sink);
	//tot = 1;
	return *this;
}

Stat_Tri_Mult& Stat_Tri_Mult::init(SS_Tri_Mult& ss, HH_Tri_Mult& _eta)
{
	stat_word.init(ss.word, _eta.eta_word);
	stat_source.init(ss.source, _eta.eta_source);
	stat_sink.init(ss.sink, _eta.eta_sink);
	tot = 1;
	return *this;
}

Stat_Tri_Mult& Stat_Tri_Mult::init(Stat_Tri_Mult& stat, HH_Tri_Mult& _eta)
{
	stat_word.init(stat.stat_word, _eta.eta_word);
	stat_source.init(stat.stat_source, _eta.eta_source);
	stat_sink.init(stat.stat_sink, _eta.eta_sink);
	tot = stat.tot;
	return *this;
}

Stat_Tri_Mult& Stat_Tri_Mult::copy_ss(Stat_Tri_Mult& stat)
{
	stat_source = stat.stat_source;
	stat_sink = stat.stat_sink;
	return *this;
}

Stat_Tri_Mult& Stat_Tri_Mult::update_ss(Stat_Tri_Mult& stat)
{
	stat_source.part_update(stat.stat_source);
	stat_sink.part_update(stat.stat_sink);
	//tot += stat.tot;
	return *this;
}

Stat_Tri_Mult& Stat_Tri_Mult::update(Stat_Tri_Mult& stat)
{
	stat_word.part_update(stat.stat_word);
	stat_source.part_update(stat.stat_source);
	stat_sink.part_update(stat.stat_sink);
	tot += stat.tot;
	return *this;
}

void Stat_Tri_Mult::clear_inds()
{
	stat_word.clear_inds();
	stat_source.clear_inds();
	stat_sink.clear_inds();
}

bool Stat_Tri_Mult::check_stat()
{
	if (!stat_word.check_stat(tot))
	{
		cout << "error in stat_word" << endl;
		return false;
	}
	if (!stat_source.check_stat(tot))
	{
		cout << "error in stat_source" << endl;
		return false;
	}
	if (!stat_sink.check_stat(tot))
	{
		cout << "error in stat_sink" << endl;
		return false;
	}
	return true;
}









void Tri_Mult::initialize_eta(HH_Tri_Mult& _eta)
{
	Multinomial::initialize_eta(_eta.eta_word, eta.eta_word);//这里的eta是Tri_Mult 的私有变量
	
	Multinomial::initialize_eta(_eta.eta_source, eta.eta_source);
	Multinomial::initialize_eta(_eta.eta_sink, eta.eta_sink);
	
}

double Tri_Mult::marg_likelihood(QQ_Tri_Mult& qq, Stat_Tri_Mult& stat)
{
	double lik = 0.0;
	lik += Multinomial::marg_likelihood(qq.qq_word, stat.stat_word, log_vals.log_vals_word, stat.tot);
	lik += Multinomial::marg_likelihood(qq.qq_source, stat.stat_source, log_vals.log_vals_source, stat.tot);
	lik += Multinomial::marg_likelihood(qq.qq_sink, stat.stat_sink, log_vals.log_vals_sink, stat.tot);
	return lik;
}

void Tri_Mult::add_data(QQ_Tri_Mult& qq, SS_Tri_Mult& ss)
{
	Multinomial::add_data(qq.qq_word, ss.word);
	Multinomial::add_data(qq.qq_source, ss.source);
	//cout << "here" << endl;
	Multinomial::add_data(qq.qq_sink, ss.sink);
	//cout << "here" << endl;
}

void Tri_Mult::add_data(QQ_Tri_Mult& qq, Stat_Tri_Mult& stat)
{
	Multinomial::add_data(qq.qq_word, stat.stat_word, stat.tot);
	Multinomial::add_data(qq.qq_source, stat.stat_source, stat.tot);
	Multinomial::add_data(qq.qq_sink, stat.stat_sink, stat.tot);
}

void Tri_Mult::del_data(QQ_Tri_Mult& qq, Stat_Tri_Mult& stat)
{
	Multinomial::del_data(qq.qq_word, stat.stat_word, stat.tot);//qq是整个团簇的统计量
	Multinomial::del_data(qq.qq_source, stat.stat_source, stat.tot);
	Multinomial::del_data(qq.qq_sink, stat.stat_sink, stat.tot);
}

list< QQ_Tri_Mult >::iterator Tri_Mult::add_class()
{
	return classqq.insert(classqq.end(), QQ_Tri_Mult(eta));
}

void Tri_Mult::del_class(list< QQ_Tri_Mult >::iterator it)
{
	classqq.erase(it);
}

void Tri_Mult::output(string& save_dir, int iter)
{
	if (save_dir.back() != '/')
	{
		save_dir += '/';
	}
	ostringstream file_name_stream_word, file_name_stream_source, file_name_stream_sink;
	file_name_stream_word << save_dir << "classqq_word" << iter << ".txt";
	file_name_stream_source << save_dir << "classqq_source" << iter << ".txt";
	file_name_stream_sink << save_dir << "classqq_sink" << iter << ".txt";
	ofstream output_stream_word(file_name_stream_word.str().c_str());
	ofstream output_stream_source(file_name_stream_source.str().c_str());
	ofstream output_stream_sink(file_name_stream_sink.str().c_str());
	cout << "saving topic data at iteration " << iter << " ..." << endl;
	list< QQ_Tri_Mult >::iterator it_q;
	vector<int>::iterator it, end;
	for (it_q = classqq.begin(); it_q != classqq.end(); it_q++)
	{
		end = it_q->qq_word.end() - 1;
		for (it = it_q->qq_word.begin(); it != end; it++)
		{
			output_stream_word << *it << " ";
		}
		output_stream_word << endl;

		end = it_q->qq_source.end() - 1;
		for (it = it_q->qq_source.begin(); it != end; it++)
		{
			output_stream_source << *it << " ";
		}
		output_stream_source << endl;

		end = it_q->qq_sink.end() - 1;
		for (it = it_q->qq_sink.begin(); it != end; it++)
		{
			output_stream_sink << *it << " ";
		}
		output_stream_sink << endl;
	}
	output_stream_word.close();
	output_stream_source.close();
	output_stream_sink.close();
}

void Tri_Mult::reset_class(QQ_Tri_Mult& qq)
{
	qq.qq_word.assign(eta.eta_word.size(), 0);
	qq.qq_source.assign(eta.eta_source.size(), 0);
	qq.qq_sink.assign(eta.eta_sink.size(), 0);
}

void Tri_Mult::init_log_pos_vals(int tot_num_words)
{
	Multinomial::init_log_pos_vals(tot_num_words, log_vals.log_vals_word, eta.eta_word);
	Multinomial::init_log_pos_vals(tot_num_words, log_vals.log_vals_source, eta.eta_source);
	Multinomial::init_log_pos_vals(tot_num_words, log_vals.log_vals_sink, eta.eta_sink);
}

bool Tri_Mult::check_qq(QQ_Tri_Mult& qq)
{
	if (!Multinomial::check_qq(qq.qq_word))
	{
		cout << "Error in qq_word" << endl;
		return false;
	}
	if (!Multinomial::check_qq(qq.qq_source))
	{
		cout << "Error in qq_source" << endl;
		return false;
	}
	if (!Multinomial::check_qq(qq.qq_sink))
	{
		cout << "Error in qq_sink" << endl;
		return false;
	}
	return true;
}
