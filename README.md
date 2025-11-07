# Conference data management system

## Description 

The following files contain a **SQL script** and **Java code** which is used to create a database that is used to manage research papers with their respected authors while also having reviewers who can review each paper. Each author and reviewer is uniquely idenitified through an email, each paper will have a unique ID which is authomatically assigned by the system. Furthermore there is also a system which allows the author/reviewer to log into the database, everytime a user logs in, the system creates logs to track which person logs in. 

All these things have been implemented through a SQL script while the remaining have been implemented through Java using JavaFx. 

## Features

For the **SQL script** the following objects have been implemented,
- Tables
- Triggers
- Sequences
- Views
- Procedures

For the **JavaFX Application** ,
- Displays a login interface for authors and reviewers
- Validates credentials against the database
- Allows author to create their new paper entry
- Allows reviewers to view the paper that has been published while allowing them to enter their review
- Papers and reviews made gets stored into the SQL database

## How it works
1. Run the SQL script to set up the database.
2. Launch the JavaFX Application
3. Enter login credentials
4. Depending on who you are (*author/reviewer*) you will be displayed a different interface.

## Technologies Used
1. Java
2. SQL
3. JDBC
