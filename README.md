# Digital Music Store Data Analysis

![SQL](https://img.shields.io/badge/SQL-MySQL-blue?logo=mysql&style=flat-square)
![Data Analysis](https://img.shields.io/badge/Data%20Analysis-Relational%20Databases-success?style=flat-square)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=flat-square)

## Project Overview
In the highly competitive digital music and media retail industry, businesses generate vast amounts of transactional and demographic data daily. However, without structured querying and analysis, leadership struggles to identify key revenue drivers, understand regional purchasing behaviors, or optimize targeted marketing campaigns. 

This project involves the deployment and analysis of a fully normalized relational database (`MUSICSTORE`) to uncover actionable insights regarding employee performance, high-value customer segmentation, and global media trends to drive strategic decision-making.

## Primary Objectives
* **Database Implementation & Management:** Deployed a fully normalized relational database using a MySQL Workbench model, managing relationships across 11 core entities including `Customer`, `Invoice`, `Track`, `Album`, and `Artist`.
* **Customer Segmentation & Regional Analysis:** Utilized complex SQL joins and aggregations to identify top-spending customers and pinpoint the most lucrative cities and countries for targeted promotional events.
* **Product & Trend Evaluation:** Analyzed purchasing patterns to determine the most popular music genres per country and the top-selling bands based on track counts.
* **Internal Operations Review:** Evaluated the organizational structure by querying the `Employee` table to determine hierarchical leadership and reporting lines.

## Tech Stack & Tools
* **Database Management System:** MySQL 8.0
* **Database Design & Modeling:** MySQL Workbench (EER Diagrams)
* **Query Language:** Advanced SQL (CTEs, Window Functions, Complex Joins, Aggregations)

## Database Schema
The `MUSICSTORE` database is highly normalized to ensure data integrity. The core architecture includes:
* **Sales Data:** `Invoice`, `InvoiceLine` (Tracks transactional history and line-item details).
* **Customer Data:** `Customer`, `Employee` (Tracks buyer demographics and assigned support representatives).
* **Product Catalog:** `Track`, `Album`, `Artist`, `Genre`, `MediaType`, `Playlist`, `PlaylistTrack` (Maintains the hierarchical structure of the music inventory).

*(Optional: Insert an image of your ER Diagram here by dragging and dropping the `ER_DIAGRAM.png` file into your GitHub README editor).*

## Key Business Questions Answered
This project uses advanced SQL queries to answer critical business questions, including:
1. **Who is the senior-most employee based on job title?** (Demonstrates basic querying and sorting).
2. **Which city has the best customers?** (Identifies the city with the highest sum of invoice totals for promotional targeting).
3. **Who is the top spending customer?** (Utilizes `JOIN`s to connect customer profiles with total invoice aggregates).
4. **Who are the top 10 rock bands?** (Involves multi-table `JOIN`s spanning Artist, Album, Track, and Genre tables).
5. **What is the most popular music genre for each country?** (Showcases advanced SQL using **Common Table Expressions (CTEs)** and the `RANK()` **Window Function** to handle ties).
6. **Who is the highest-spending customer in each country?** (Utilizes partitioned window functions to find regional top-performers).

## How to Run the Project
1. Clone this repository to your local machine.
2. Open MySQL Workbench.
3. Run the `Music_Store_Data_Analysis.sql` script. 
    * *Note: Ensure your `secure_file_priv` settings in MySQL are configured correctly to allow bulk data imports using `LOAD DATA INFILE`.*
4. Execute the analytical queries provided in the script to view the generated business insights.

## Future Scope
* **Data Visualization:** Connect the SQL database directly to BI tools like Tableau or Power BI to build interactive dashboards mapping global sales hotspots and genre popularity.
* **Cohort Analysis:** Expand the SQL scripts to analyze customer retention and lifetime value (CLV) based on their first purchase date.

---
*Developed by Jay patwa/https://jaypatwa21.github.io/*
