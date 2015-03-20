Demo application deployed on [OpenShift](http://www.openshift.com/) SaaS. 

[Daily Wholesale Price of Fruits and Vegetables](http://tokyo2-fruitvegemarket.rhcloud.com/) (Japanese)

It shows daily wholesale prices of fruits and vegetables at Ohta Market, a part of Tokyo Metropolitan Central Wholesale Market. 
Unlike the original price summary page, which only allows user to see whole prices of each day, my summary page shows shift in price of each crop. 

e.g. Wholesale price of crops on 2015/03/19 ([Link](http://www.shijou-nippo.metro.tokyo.jp/SN/201503/20150319/Sei/SN_Sei_Oota.html))

The application is written in Perl and built with [Dancer](http://www.perldancer.org/), a light weight application framework. 
It is a PSGI(Plack) application running on Apache2. 

Perl 5.10 / MySQL 5.5

I use modules like:
* Moose
* DBIx::Class
* Template::Toolkit
* Test::More
* Plack::Test
