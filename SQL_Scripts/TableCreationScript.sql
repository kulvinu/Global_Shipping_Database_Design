-- Creating tables

-- Department Table
CREATE TABLE Department (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(200)
);

-- Role Table
CREATE TABLE Role (
    role_id NUMBER PRIMARY KEY,
    role_name VARCHAR2(50) NOT NULL,
    department_id NUMBER NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- Employee Table
CREATE TABLE Employee (
    emp_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(100) NOT NULL,
    emp_email VARCHAR2(100) UNIQUE,
    role_id NUMBER NOT NULL,
    nationality VARCHAR2(50),
    date_of_birth DATE,
    address VARCHAR2(100),
    emp_date DATE NOT NULL,
    FOREIGN KEY (role_id) REFERENCES Role(role_id),
    CONSTRAINT Chk_DOB CHECK (date_of_birth < SYSDATE)
);

-- Table License
CREATE TABLE License (
    license_id NUMBER PRIMARY KEY,
    emp_id NUMBER NOT NULL,
    license_type VARCHAR2(50),
    issue_date DATE,
    expiry_date DATE,
    license_status VARCHAR2(20),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    CONSTRAINT Chk_Lic_Status CHECK (license_status IN ('Valid', 'Invalid')),
    CONSTRAINT Chk_Lic_date CHECK (issue_date < expiry_date)
);

-- Table Vessel Type
CREATE TABLE Vessel_Type (
    vessel_type_id VARCHAR2(5) PRIMARY KEY,
    vessel_type VARCHAR2(50),
    length NUMBER(6,2),
    capacity NUMBER,
    typical_crew_required NUMBER,
    CONSTRAINT Chk_V_Length CHECK (length > 0),
    CONSTRAINT Chk_V_Capacity CHECK (capacity > 0),
    CONSTRAINT Chk_V_Crew CHECK (typical_crew_required > 0),
    CONSTRAINT Chk_V_Name CHECK (vessel_type_id = UPPER(vessel_type_id))
);

-- Table Vessel
CREATE TABLE Vessel (
    imo_no NUMBER PRIMARY KEY,
    vessel_type_id VARCHAR2(5) NOT NULL,
    vessel_name VARCHAR2(100) NOT NULL,
    speed NUMBER(5,2),
    gross_tonnage NUMBER,
    length NUMBER(6,2),
    breadth NUMBER(6,2),
    built_date DATE,
    FOREIGN KEY (vessel_type_id) REFERENCES Vessel_Type(vessel_type_id),
    CONSTRAINT Chk_S_Speed CHECK (speed > 0),
    CONSTRAINT Chk_S_Tonnage CHECK (gross_tonnage > 0),
    CONSTRAINT Chk_S_Length CHECK (length > 0),
    CONSTRAINT Chk_S_breadth CHECK (breadth > 0)
);

-- Table Customer
CREATE TABLE Customer (
    customer_id NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100) NOT NULL,
    customer_email VARCHAR2(100) NOT NULL UNIQUE,
    customer_tel_no VARCHAR2(20) NOT NULL,
    cust_address VARCHAR2(255),
    cust_bill_address VARCHAR2(255) NOT NULL,
    cust_country VARCHAR2(50),
    created_on DATE DEFAULT SYSDATE
);

-- Table Route
CREATE TABLE Route (
    route_id NUMBER PRIMARY KEY,
    route_name VARCHAR2(100) NOT NULL,
    actual_distance NUMBER(7,2),
    estimated_duration INTERVAL DAY TO SECOND,
    CONSTRAINT Chk_R_Distance CHECK (actual_distance > 0)
);

-- Table Route Schedule
CREATE TABLE Route_Schedule (
    schedule_id NUMBER PRIMARY KEY,
    route_id NUMBER NOT NULL,
    vessel_id NUMBER NOT NULL,
    arrival_date DATE NOT NULL,
    departure_date DATE NOT NULL,
    FOREIGN KEY (route_id) REFERENCES Route(route_id),
    FOREIGN KEY (vessel_id) REFERENCES Vessel(imo_no),
    CONSTRAINT Chk_RS_Date CHECK (departure_date <= arrival_date)
);

-- Table Voyage
CREATE TABLE Voyage (
    voyage_id NUMBER PRIMARY KEY,
    vessel_id NUMBER NOT NULL,
    schedule_id NUMBER NOT NULL,
    actual_departure_date DATE,
    actual_arrival_date DATE,
    FOREIGN KEY (vessel_id) REFERENCES Vessel(imo_no),
    FOREIGN KEY (schedule_id) REFERENCES Route_Schedule(schedule_id)
);

-- Table Port
CREATE TABLE Port (
    port_id NUMBER PRIMARY KEY,
    port_name VARCHAR2(100) NOT NULL UNIQUE,
    port_address VARCHAR2(100),
    port_number VARCHAR2(20),
    port_email VARCHAR2(100) UNIQUE
);

-- Table Segment
CREATE TABLE Segment (
    seg_id NUMBER PRIMARY KEY,
    dep_port NUMBER NOT NULL,
    arrival_port NUMBER NOT NULL,
    distance NUMBER(6,2),
    estimated_time INTERVAL DAY TO SECOND,
    FOREIGN KEY (dep_port) REFERENCES Port(port_id),
    FOREIGN KEY (arrival_port) REFERENCES Port(port_id),
    CONSTRAINT Chk_Seg_Port CHECK (dep_port <> arrival_port)
);

-- Table Route Seg Assignment
CREATE TABLE Route_Seg_Assignment (
    route_id NUMBER NOT NULL,
    segment_id NUMBER NOT NULL,
    segment_order NUMBER,
    PRIMARY KEY (route_id, segment_id),
    FOREIGN KEY (route_id) REFERENCES Route(route_id),
    FOREIGN KEY (segment_id) REFERENCES Segment(seg_id),
    CONSTRAINT Chk_RSeg_Order CHECK (segment_order > 0)
);

-- Table Segment Schedule
CREATE TABLE Segment_Schedule (
    schedule_id NUMBER NOT NULL,
    segment_id NUMBER NOT NULL,
    planned_departure_date DATE,
    planned_arrival_date DATE,
    actual_depart_date DATE,
    actual_arrival_date DATE,
    PRIMARY KEY (schedule_id, segment_id),
    FOREIGN KEY (schedule_id) REFERENCES Route_Schedule(schedule_id),
    FOREIGN KEY (segment_id) REFERENCES Segment(seg_id),
    CONSTRAINT Chk_SegSchedule_Date CHECK (planned_departure_date <= planned_arrival_date)
);



-- Table Crew Assignment
CREATE TABLE Crew_Assignment (
    crew_id NUMBER PRIMARY KEY,
    emp_id NUMBER NOT NULL,
    schedule_id NUMBER NOT NULL,
    assigned_on DATE DEFAULT SYSDATE,
    released_on DATE,
    status VARCHAR2(20),
    UNIQUE (emp_id, schedule_id),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    FOREIGN KEY (schedule_id) REFERENCES Route_Schedule(schedule_id),
    CONSTRAINT Chk_CA_Status CHECK (status IN ('Assigned','Active','Completed','Cancelled')),
    CONSTRAINT Chk_CA_Date CHECK (released_on IS NULL OR assigned_on <= released_on)
);

-- Table Container Type
CREATE TABLE Container_Type (
    container_type_id NUMBER PRIMARY KEY,
    container_type VARCHAR2(50) NOT NULL,
    length NUMBER(5,2),
    width NUMBER(5,2),
    height NUMBER(5,2),
    weight NUMBER(6,2),
    CONSTRAINT Chk_CT_length CHECK (length > 0),
    CONSTRAINT Chk_CT_width  CHECK (width > 0),
    CONSTRAINT Chk_CT_height CHECK (height > 0),
    CONSTRAINT Chk_CT_weight CHECK (weight > 0)
);

-- Table Container
CREATE TABLE Container (
    container_id NUMBER PRIMARY KEY,
    container_type_id NUMBER NOT NULL,
    container_name VARCHAR2(50),
    FOREIGN KEY (container_type_id) REFERENCES Container_Type(container_type_id)
);

-- Table Booking
CREATE TABLE Booking (
    booking_id NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    booking_date DATE NOT NULL,
    container_id NUMBER NOT NULL,
    schedule_id NUMBER NOT NULL,
    origin_port NUMBER NOT NULL,
    destination_port NUMBER NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (container_id) REFERENCES Container(container_id),
    FOREIGN KEY (schedule_id) REFERENCES Route_Schedule(schedule_id),
    FOREIGN KEY (origin_port) REFERENCES Port(port_id),
    FOREIGN KEY (destination_port) REFERENCES Port(port_id),
    CONSTRAINT Chk_Booking_Port CHECK (origin_port <> destination_port)
);

-- Table Goods_Type
CREATE TABLE Goods_Type (
    goods_type_id VARCHAR2(25) PRIMARY KEY,
    goods_type_name VARCHAR2(50) UNIQUE NOT NULL
);

-- Table Goods
CREATE TABLE Goods (
    goods_id NUMBER PRIMARY KEY,
    container_id NUMBER NOT NULL,
    goods_type_id VARCHAR2(25) NOT NULL,
    quantity NUMBER,
    weight NUMBER(6,2),
    volume NUMBER(6,2),
    loaded_on DATE,
    unloaded_on DATE,
    FOREIGN KEY (goods_type_id) REFERENCES Goods_Type(goods_type_id)
    FOREIGN KEY (container_id) REFERENCES Container(container_id),
    CONSTRAINT Chk_Goods_Quantity CHECK (quantity > 0),
    CONSTRAINT Chk_Goods_Weight CHECK (weight > 0),
    CONSTRAINT Chk_Goods_Volume CHECK (volume > 0),
    CONSTRAINT Chk_Goods_Date CHECK (unloaded_on IS NULL OR loaded_on <= unloaded_on)
);

-- Table Container Movement
CREATE TABLE Container_Movement (
    movement_id NUMBER PRIMARY KEY,
    container_id NUMBER NOT NULL,
    port_id NUMBER NOT NULL,
    voyage_id NUMBER NOT NULL,
    booking_id NUMBER NOT NULL,
    movement_type VARCHAR2(20),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (container_id) REFERENCES Container(container_id),
    FOREIGN KEY (port_id) REFERENCES Port(port_id),
    FOREIGN KEY (voyage_id) REFERENCES Voyage(voyage_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    CONSTRAINT Chk_CM_MovType CHECK (movement_type IN ('Loaded', 'Unloaded', 'In Transit', 'Delivered')
);
