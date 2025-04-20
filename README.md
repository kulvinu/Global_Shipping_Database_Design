# Global_Shipping_Database_Design

A fully normalized, SQL-driven relational database system for a global logistics and shipping company. This project simulates real-world complexity: booking containers, tracking goods, managing routes and schedules, assigning crew, and analysing operations through advanced SQL queries.

---

## 🚀 Key Features

- **Entity-Relationship Design** with business rule assumptions
- **Normalized relational schema** with 20+ interlinked tables
- **Robust SQL DDL scripts** with constraints, checks, and referential integrity
- **Data population scripts** with realistic multiplicity and reusability
- **Business logic enforcement** using triggers and procedures
- **Advanced SQL analytics** using:
  - Aggregates
  - Window functions
  - CTEs
  - Subqueries
  - CASE statements
- **Views and Reports** for operations monitoring
- **Stored procedures** for port and voyage analytics

---

## 🧱 Database Design Highlights

- **Booking system** for containers and goods (one container per booking, one type of goods per container)
- **Segmented routes** with reusable port-to-port segments and ordered route logic
- **Voyage execution** tracking actual vs. planned data
- **Crew assignments** enforced against vessel type crew requirements
- **Movement logging** per container, voyage, and port
- **Goods classification** using a standardized `goods_type` model

---

## 🔎 Complex SQL Queries (Sample Use Cases)

- Top 3 most reused containers per customer in the last 12 months
- Customers shipping the most hazardous cargo
- Average delivery time by goods type
- Ports with highest traffic and route coverage
- Voyage summary view showing delays and delivery stats
- Crew assignment enforcement via trigger logic

---

