# Application_Monitoring_Dashboards

## Creating Database
In MySQL
```mysql
CREATE USER 'wsluser'@'%' IDENTIFIED BY 'wslpass';
GRANT ALL PRIVILEGES ON *.* TO 'wsluser'@'%';
FLUSH PRIVILEGES;
```
```mysql
CREATE DATABASE logs_db;
```

## To Run:

- inside /docker 
```bash
docker-compose up --build
```

- in another terminal - /workload_simulator 
```bash 
python3 simulate_requests.py
```
- in another terminal - /kafka
```bash 
python3 producer.py
```

- in another terminal - /KafkaConsumer 
```bash 
python3 consumer.py
```