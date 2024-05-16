import psycopg2

# Function to execute a query and return the results
def execute_query(query, cursor):
    cursor.execute(query)
    return cursor.fetchall()

# Connect to PostgreSQL database
def main():
    # Database connection setup
    try:
        conn = psycopg2.connect(
            dbname="alt_school_db",
            user="alt_school_user",
            password="secretPassw0rd",
            host="localhost",
            port="5434"  # Port mapped in Docker Compose
        )
        print("Connected to PostgreSQL database!")
        
        # Open a cursor to perform database operations
        cur = conn.cursor()

        # Execute a query to count records
        cur.execute("SELECT COUNT(*) FROM FIT_PRO.PRODUCTS")

        # Fetch the result
        count = cur.fetchone()[0]
        print("Number of records:", count)

        # Close cursor and connection
        cur.close()
        conn.close()
        
    except psycopg2.Error as e:
        print(f"Database error: {e}")
    except Exception as e:
        print(f"Error: {e}")

# Call the main function to execute the code
if __name__ == "__main__":
    main()
