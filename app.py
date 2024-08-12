import streamlit as st
import sqlite3
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime
import pandas as pd

# Database connection
def get_connection():
    try:
        connection = sqlite3.connect("leave_management.db")  # Use SQLite file
        return connection
    except sqlite3.Error as e:
        st.error(f"Error connecting to the database: {e}")
        return None

# Fetch data from the database
def fetch_data(query, params=None):
    connection = get_connection()
    if connection is None:
        return []
    try:
        cursor = connection.cursor()
        cursor.execute(query, params or ())
        data = cursor.fetchall()
        return data
    except sqlite3.Error as e:
        st.error(f"Error executing query: {e}")
        return []
    finally:
        connection.close()

# Insert data into the database
def insert_data(query, params):
    connection = get_connection()
    if connection is None:
        return False
    try:
        cursor = connection.cursor()
        cursor.execute(query, params)
        connection.commit()
        return True
    except sqlite3.Error as e:
        st.error(f"Error executing query: {e}")
        return False
    finally:
        connection.close()

# Function to hash passwords
def hash_password(password):
    return generate_password_hash(password)

# Function to check password hash
def verify_password(stored_password_hash, password):
    return check_password_hash(stored_password_hash, password)

def show_first_page():
    st.title("Leave Management System")

    # Create tabs for Sign Up and Log In
    tab1, tab2 = st.tabs(["Sign Up", "Log In"])

    # Sign Up Tab
    with tab1:
        st.subheader("Sign Up")
        name = st.text_input("Name")
        email = st.text_input("Email")
        password = st.text_input("Password", type="password")
        role = st.selectbox("Role", ["Manager", "Employee"])
        manager_email = st.text_input("Manager Email") if role == "Employee" else ""

        if st.button("Sign Up"):
            # Step 1: Check if all fields are filled
            if not all([name, email, password, role]) or (role == "Employee" and not manager_email):
                st.warning("Please fill up all required information!")
                return

            # Step 2: Check the role
            if role == "Employee":
                # Step 3: Look up email in emp_info
                existing_employee_query = "SELECT email FROM emp_info WHERE email = ?"
                if fetch_data(existing_employee_query, (email,)):
                    st.warning("Sign up failed! The account has already existed.")
                    return
                # Step 5: Validate manager email
                manager_check_query = "SELECT email FROM man_info WHERE email = ?"
                if not fetch_data(manager_check_query, (manager_email,)):
                    st.warning("Sign up failed! Wrong manager email.")
                    return
            else:  # Manager
                # Step 4: Look up email in man_info
                existing_manager_query = "SELECT email FROM man_info WHERE email = ?"
                if fetch_data(existing_manager_query, (email,)):
                    st.warning("Sign up failed! The account has already existed.")
                    return

            # Step 6: Insert new user into user_info
            new_user_id_query = "SELECT MAX(user_id) FROM user_info"
            new_user_id = fetch_data(new_user_id_query)[0][0] + 1 if fetch_data(new_user_id_query) else 1
            insert_user_query = """
                INSERT INTO user_info (user_id, role)
                VALUES (?, ?)
            """
            if insert_data(insert_user_query, (new_user_id, role)):
                # Insert into emp_info or man_info based on role
                hashed_password = generate_password_hash(password)
                if role == "Employee":
                    insert_emp_query = """
                        INSERT INTO emp_info (user_id, name, email, role, manager_email, password)
                        VALUES (?, ?, ?, ?, ?, ?)
                    """
                    if insert_data(insert_emp_query, (new_user_id, name, email, role, manager_email, hashed_password)):
                        st.success("Sign up successfully!")
                    else:
                        st.error("Sign up failed. Please try again.")
                elif role == "Manager":
                    insert_man_query = """
                        INSERT INTO man_info (user_id, name, email, role, password)
                        VALUES (?, ?, ?, ?, ?)
                    """
                    if insert_data(insert_man_query, (new_user_id, name, email, role, hashed_password)):
                        st.success("Sign up successfully!")
                    else:
                        st.error("Sign up failed. Please try again.")
            else:
                st.error("Sign up failed. Please try again.")

    # Log In Tab
    with tab2:
        st.subheader("Log In")
        email = st.text_input("Email", key="login_email")
        password = st.text_input("Password", type="password", key="login_password")
        role = st.selectbox("Role", ["Manager", "Employee"], key="login_role")

        if st.button("Log In"):
            # Step 1: Check if all fields are filled
            if not all([email, password, role]):
                st.warning("Please fill up all required information!")
                return

            # Step 2: Check the role
            if role == "Employee":
                # Step 3: Look up email in emp_info
                employee_check_query = "SELECT password FROM emp_info WHERE email = ?"
                result = fetch_data(employee_check_query, (email,))
                if not result:
                    st.warning("Log In failed! The account does not exist. Please Sign Up.")
                    return

                # Step 4: Verify password
                stored_password_hash = result[0][0]
                if not verify_password(stored_password_hash, password):
                    st.warning("Log In failed! Wrong Password!")
                    return

                # Redirect to Employee page
                st.success("Log In successful!")
                st.session_state.email = email  # Store email in session state
                st.session_state.page = 2

            elif role == "Manager":
                # Step 5: Look up email in man_info
                manager_check_query = "SELECT password FROM man_info WHERE email = ?"
                result = fetch_data(manager_check_query, (email,))
                if not result:
                    st.warning("Log In failed! The account does not exist. Please Sign Up.")
                    return

                # Step 6: Verify password
                stored_password_hash = result[0][0]
                if not verify_password(stored_password_hash, password):
                    st.warning("Log In failed! Wrong Password!")
                    return

                # Redirect to Manager page
                st.success("Log In successful!")
                st.session_state.email = email  # Store email in session state
                st.session_state.page = 3

def get_emp_id(email):
    query = "SELECT user_id FROM emp_info WHERE email = ?"
    result = fetch_data(query, (email,))
    return result[0][0] if result else None

def show_second_page():
    st.title("Leave Management System for Employee")

    # Check if the user's email is stored in session state
    if "email" not in st.session_state:
        st.error("User email not found. Please log in again.")
        st.session_state.page = 1
        return

    # Sidebar with Log Out Button
    with st.sidebar:
        if st.button("Log Out"):
            st.session_state.page = 1
            st.rerun()
            return

    # Create tabs for Create Request and Manage Request
    tab1, tab2 = st.tabs(["Create Request", "Manage Request"])

    # Initialize successful submission count in session state
    if "successful_submissions" not in st.session_state:
        st.session_state.successful_submissions = 0

    # Create Request Tab
    with tab1:
        st.subheader("Create Leave Request")
        leave_type = st.selectbox("Type of Leave", ["Personal", "Sick", "Official", "Other"])
        comment = st.text_area("Comment (Reason for leave)")

        if st.button("Submit"):
            # Step 1: Check submission limit
            if st.session_state.successful_submissions >= 10:
                st.warning("You've already submitted 10 requests. You will be logged out if trying to send more requests.")
                st.session_state.page = 1
                return

            # Step 2: Check if all fields are filled
            if not all([leave_type, comment]):
                st.warning("Please fill up all required information!")
                return

            # Step 3: Insert the new leave request into the database
            user_id = get_emp_id(st.session_state.email)
            if not user_id:
                st.error("User ID not found. Please log in again.")
                st.session_state.page = 1
                return

            insert_query = """
                INSERT INTO leave_info (user_id, leave_type, comment, status, time)
                VALUES (?, ?, ?, ?, ?)
            """
            if insert_data(insert_query, (user_id, leave_type, comment, "Waiting", datetime.now())):
                st.session_state.successful_submissions += 1
                st.success("Leave request submitted successfully!")
            else:
                st.error("Failed to submit leave request. Please try again.")

    # Manage Request Tab
    with tab2:
        st.subheader("Manage Leave Requests")
        if st.button("Show Requests"):
            user_id = get_emp_id(st.session_state.email)
            if not user_id:
                st.error("User ID not found. Please log in again.")
                st.session_state.page = 1
                # st.rerun()
                return

            query = """
                SELECT r.time, r.leave_type, e.manager_email, r.comment, r.status
                FROM leave_info r
                JOIN emp_info e ON r.user_id = e.user_id
                WHERE r.user_id = ?
            """
            requests = fetch_data(query, (user_id,))

            if requests:
                st.table(
                    [{
                        "Date of Application": r[0],
                        "Leave Type": r[1],
                        "Manager Name": r[2],
                        "Comment (Reason for leave)": r[3],
                        "Status": r[4]
                    } for r in requests]
                )
            else:
                st.info("No leave requests found.")

def show_third_page():
    st.title("Leave Management System for Manager")

    # Check if the user's email is stored in session state
    if "email" not in st.session_state:
        st.error("User email not found. Please log in again.")
        st.session_state.page = 1
        #st.rerun()
        return

    # Sidebar with Log Out Button
    with st.sidebar:
        if st.button("Log Out"):
            st.session_state.page = 1
            st.rerun()
            return

    # Fetch manager's email from session state
    manager_email = st.session_state.email

    # Query to fetch leave requests for employees under this manager
    query = """
        SELECT l.request_id, e.name, l.time, l.leave_type, l.comment, l.status
        FROM leave_info l
        JOIN emp_info e ON l.user_id = e.user_id
        JOIN user_info u ON e.user_id = u.user_id
        WHERE e.manager_email = ?
    """
    leave_requests = fetch_data(query, (manager_email,))

    if leave_requests:
        for request in leave_requests:
            request_id, employee_name, created_time, leave_type, comment, status = request
            st.write(f"**Employee Name:** {employee_name}")
            st.write(f"**Date of Application:** {created_time}")
            st.write(f"**Leave Type:** {leave_type}")
            st.write(f"**Comment:** {comment}")
            st.write(f"**Status:** {status}")

            if status == "Waiting":
                col1, col2 = st.columns([1, 1])
                with col1:
                    if st.button("Approve", key=f"approve_{request_id}"):
                        update_query = "UPDATE leave_info SET status = ? WHERE request_id = ?"
                        if insert_data(update_query, ("Approved", request_id)):
                            st.success("Request approved.")
                with col2:
                    if st.button("Reject", key=f"reject_{request_id}"):
                        update_query = "UPDATE leave_info SET status = %s WHERE request_id = ?"
                        if insert_data(update_query, ("Rejected", request_id)):
                            st.success("Request rejected.")
            st.markdown("---")
    else:
        st.info("No leave requests found.")

# Define your main function
def main():
    if "page" not in st.session_state:
        st.session_state.page = 1
    if "tab" not in st.session_state:
        st.session_state.tab = "Sign Up"

    if st.session_state.page == 1:
        show_first_page()
    elif st.session_state.page == 2:
        show_second_page()
    elif st.session_state.page == 3:
        show_third_page()

if __name__ == "__main__":
    main()
