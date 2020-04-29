# Abstract -

The purpose of this IMDB Database project is to create a database consisting of TV show information gathered from popular rating websites as well as the social media. The data collected for this project was extracted from a myriad of sources such as web scraping of imdb.com using Python libraries, crawling  of Twitter & Youtube REST APIs, and a dataset consisting of the ratings of TV shows from Netflix. The goal of this Project is to create a thematic data model that can integrate all these sources & load it into the MySQL database .

# Files & Folders - 

- Conceptual Model.png - Conceptual Model of the Database
- TVDB DDL.sql - Contains the DDL scripts to create the database and the tables in TVDB
- IMDB_Webscraping.ipynb - Entire Webscraping & File Export
- Twitter_API.ipynb - Twitter data extraction & File Export
- Youtube_API.ipynb - Youtube data extraction & File Export
- Netflix_Rating.ipynb - Cleaning & Tranformation of Netflix rating & File Export
- Data - Complete Folder of extracted, cleaned & transformed CSVs ready to be dumped in the MySQL Database
- TVDB DML.sql - Scripts that contain the transformation that was done on the stage tables and the data while loading into the main tables
- Physical ER Model.jpeg - Physical Model of the Destination area after Normalization
- SQL Scripts - Complete Folder of scripts written for Normalization & to create indexes, views, functions, procedures etc on the MySWL Database
- Actions.pdf - Report of few of the actions performed on the database
- LICENSE.txt - licensing information for the project docs
