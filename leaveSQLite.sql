-- Create user_info table
CREATE TABLE user_info (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    role TEXT NOT NULL
);

-- Create emp_info table
CREATE TABLE emp_info (
    user_id INTEGER PRIMARY KEY REFERENCES user_info(user_id),
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL,
    manager_email TEXT,
    password TEXT NOT NULL
);

-- Create man_info table
CREATE TABLE man_info (
    user_id INTEGER PRIMARY KEY REFERENCES user_info(user_id),
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL,
    password TEXT NOT NULL
);

-- Create leave_info table
CREATE TABLE leave_info (
    time DATETIME DEFAULT CURRENT_TIMESTAMP,
    request_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER REFERENCES user_info(user_id),
    leave_type TEXT NOT NULL,
    comment TEXT,
    status TEXT NOT NULL
);

-- Insert dummy data into user_info
INSERT INTO user_info (role) VALUES
('Employee'), ('Employee'), ('Employee'), ('Employee'), ('Employee'),
('Employee'), ('Employee'), ('Employee'), ('Employee'), ('Employee'),
('Employee'), ('Employee'), ('Employee'), ('Employee'), ('Employee'),
('Manager'), ('Manager'), ('Manager'), ('Manager'), ('Manager'),
('Manager'), ('Manager'), ('Manager'), ('Manager'), ('Manager');

-- Insert dummy data into emp_info
INSERT INTO emp_info (user_id, name, email, role, manager_email, password) VALUES
(1, 'John Doe', 'john.doe@example.com', 'Employee', 'manager1@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(2, 'Jane Smith', 'jane.smith@example.com', 'Employee', 'manager1@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(3, 'Alice Johnson', 'alice.johnson@example.com', 'Employee', 'manager2@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(4, 'Bob Williams', 'bob.williams@example.com', 'Employee', 'manager2@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(5, 'Charlie Brown', 'charlie.brown@example.com', 'Employee', 'manager3@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(6, 'Daisy Clark', 'daisy.clark@example.com', 'Employee', 'manager3@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(7, 'Evan Davis', 'evan.davis@example.com', 'Employee', 'manager4@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(8, 'Manager One', 'manager1@example.com', 'Employee', 'manager4@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(9, 'George Harris', 'george.harris@example.com', 'Employee', 'manager5@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(10, 'Hannah Lee', 'hannah.lee@example.com', 'Employee', 'manager1@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(11, 'Ian Martinez', 'ian.martinez@example.com', 'Employee', 'manager1@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(12, 'Jasmine Nelson', 'jasmine.nelson@example.com', 'Employee', 'manager2@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(13, 'Kevin Moore', 'kevin.moore@example.com', 'Employee', 'manager2@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(14, 'Lily Parker', 'lily.parker@example.com', 'Employee', 'manager3@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(15, 'Michael Reed', 'michael.reed@example.com', 'Employee', 'manager3@example.com', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023');

-- Insert dummy data into man_info
INSERT INTO man_info (user_id, name, email, role, password) VALUES
(16, 'Manager One', 'manager1@example.com', 'Manager', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(17, 'Manager Two', 'manager2@example.com', 'Manager', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(18, 'Manager Three', 'manager3@example.com', 'Manager', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(19, 'Manager Four', 'manager4@example.com', 'Manager', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(20, 'Manager Five', 'manager5@example.com', 'Manager', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(21, 'Manager Six', 'manager6@example.com', 'Manager', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(22, 'Manager Seven', 'manager7@example.com', 'Manager', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(23, 'Manager Eight', 'manager8@example.com', 'Manager', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(24, 'Manager Nine', 'manager9@example.com', 'Manager', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023'),
(25, 'Manager Ten', 'manager10@example.com', 'Manager', 'scrypt:32768:8:1$HTDryOLSNJAjPdMu$7ca91785ee222a891e9b8b6cc4a5f5a1678f888173728834e92ccb59c0470cb6e07aee85c7affa539b47ab903c34db152d09553a3d5a24635e2961e8b356f023');

-- Insert dummy data into leave_info
INSERT INTO leave_info (user_id, leave_type, comment, status) VALUES
(1, 'Personal', 'Attending a family event', 'Approved'),
(2, 'Sick', 'Flu symptoms', 'Waiting'),
(3, 'Official', 'Conference in Chicago', 'Approved'),
(4, 'Personal', 'Wedding anniversary', 'Rejected'),
(5, 'Sick', 'Migraine', 'Approved'),
(6, 'Personal', 'Vacation to Hawaii', 'Waiting'),
(7, 'Official', 'Training session', 'Approved'),
(8, 'Sick', 'Dental surgery', 'Rejected'),
(9, 'Personal', 'Child’s school event', 'Approved'),
(10, 'Official', 'Client meeting in Boston', 'Waiting'),
(1, 'Personal', 'Family reunion', 'Approved'),
(2, 'Sick', 'Back pain', 'Rejected'),
(3, 'Official', 'Project deadline', 'Approved');