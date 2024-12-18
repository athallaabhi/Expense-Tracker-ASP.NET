using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["username"] == null)
        {
            String url = VirtualPathUtility.ToAbsolute("~/login");
            Response.Redirect(url);
        }
        else
        {
            HelloLabel.Text = "Hello, " + Session["username"].ToString() + "!";
        }

        ShowAllExpenses();
    }

    protected void LogoutButton_Click(object sender, EventArgs e)
    {
        Session.Abandon();
        String url = VirtualPathUtility.ToAbsolute("~/login");
        Response.Redirect(url);
    }

    protected void AddExpenseButton_Click(object sender, EventArgs e)
    {
        string name = NameTextBox.Text.Trim();
        string category = CategoryTextBox.Text.Trim();
        string amount = AmountTextBox.Text.Trim();
        string date = DateTextBox.Text.Trim();
        string userId = Session["userId"] as string;

        if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(category) || string.IsNullOrEmpty(amount) || string.IsNullOrEmpty(date))
        {
            return;
        }

        if (string.IsNullOrEmpty(userId))
        {
            return;
        }

        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection dbConnection = new SqlConnection(connString))
        {
            try
            {
                dbConnection.Open();

                string insertQuery = "INSERT INTO Expenses (Name, Amount, Date, Category, UserId) VALUES (@Name, @Amount, @Date, @Category, @UserId)";
                using (SqlCommand cmd = new SqlCommand(insertQuery, dbConnection))
                {
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@Date", string.IsNullOrEmpty(date) ? DBNull.Value : (object)date);
                    cmd.Parameters.AddWithValue("@Category", category);
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    cmd.ExecuteNonQuery();

                    String url = VirtualPathUtility.ToAbsolute("~/");
                    Response.Redirect(url);

                    NameTextBox.Text = string.Empty;
                    CategoryTextBox.Text = string.Empty;
                    AmountTextBox.Text = string.Empty;
                    DateTextBox.Text = string.Empty;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
            }
        }
    }


    protected void EditExpenses(object sender, EventArgs e)
    {
        String expenseId = EditFieldID.Text;
        string name = EditFieldName.Text.Trim();
        string category = EditFieldCategory.Text.Trim();
        string amount = EditFieldAmount.Text.Trim();
        string date = EditFieldDate.Text.Trim();
        string userId = Session["userId"] as string;

        if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(category) || string.IsNullOrEmpty(amount) || string.IsNullOrEmpty(date))
        {
            return;
        }

        if (string.IsNullOrEmpty(userId))
        {
            return;
        }

        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection dbConnection = new SqlConnection(connString))
        {
            try
            {
                dbConnection.Open();

                string insertQuery = "UPDATE Expenses SET Name = @Name, Amount = @Amount, Date = @Date, Category = @Category WHERE ID = @ExpenseId";
                using (SqlCommand cmd = new SqlCommand(insertQuery, dbConnection))
                {
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@Date", string.IsNullOrEmpty(date) ? DBNull.Value : (object)date);
                    cmd.Parameters.AddWithValue("@Category", category);
                    cmd.Parameters.AddWithValue("@ExpenseId", expenseId);

                    cmd.ExecuteNonQuery();

                    String url = VirtualPathUtility.ToAbsolute("~/");
                    Response.Redirect(url);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
            }
        }
    }

    protected void DeleteExpenses(object sender, EventArgs e)
    {
        string expenseId = DeleteID.Text;
        string userId = Session["userId"].ToString();


        if (string.IsNullOrEmpty(userId))
        {
            String url = VirtualPathUtility.ToAbsolute("~/login");
            Response.Redirect(url);
            return;
        }

        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection dbConnection = new SqlConnection(connString))
        {
            try
            {
                dbConnection.Open();

                string query = "DELETE FROM Expenses WHERE ID = @ExpenseID";

                using (SqlCommand cmd = new SqlCommand(query, dbConnection))
                {

                    cmd.Parameters.AddWithValue("@ExpenseID", expenseId);

                    cmd.ExecuteNonQuery();

                    String url = VirtualPathUtility.ToAbsolute("~/");
                    Response.Redirect(url);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
            }
        }
    }



    private void ShowAllExpenses()
    {
        string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection dbConnection = new SqlConnection(connString))
        {
            try
            {
                dbConnection.Open();

                string userId = Session["userId"] as string;
                if (string.IsNullOrEmpty(userId))
                {
                    Response.Write("User is not logged in.");
                    return;
                }

                string selectQuery = "SELECT ID, Name, Amount, Date, Category FROM Expenses WHERE UserId = @UserID";

                using (SqlCommand cmd = new SqlCommand(selectQuery, dbConnection))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        adapter.Fill(dt);

                        ExpenseRepeater.DataSource = dt;
                        ExpenseRepeater.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("Error: " + ex.Message);
            }
        }
    }

    
    }