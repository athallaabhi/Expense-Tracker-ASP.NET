using System;
using System.Data.SqlClient;
using System.Web;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        StatusLabel.Visible = false;
    }

    protected void SubmitLogin(object sender, EventArgs e)
    {
        string username = UsernameField.Text.Trim();
        string password = PasswordField.Text.Trim();

        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            DisplayStatus("Both username and password is required.");
            return;
        }

        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            try
            {
                conn.Open();

                string query = "SELECT ID, Password FROM Users WHERE Username = @Username";
                string storedPassword = null;
                string userId = null;

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            reader.Read();

                            userId = reader["ID"].ToString();
                            storedPassword = reader["Password"].ToString();

                        }
                    }

                    if (storedPassword != null)
                    {

                        if (storedPassword == password)
                        {   
                            Session["username"] = username;
                            Session["userId"] = userId;
                            String routeUrl = VirtualPathUtility.ToAbsolute("~/");
                            Response.Redirect(routeUrl);
                        }
                        else
                        {
                            DisplayStatus("Invalid username or password.");
                        }
                    }
                    else
                    {
                        DisplayStatus("Invalid username or password.");
                    }
                }
            }
            catch (Exception err)
            {
                DisplayStatus("Database error.");
                System.Diagnostics.Debug.WriteLine("Database error: " + err.Message);
            }
        }
    }

    private void DisplayStatus(string message)
    {
        StatusLabel.Text = message;
        StatusLabel.Visible = true;
    }
}
