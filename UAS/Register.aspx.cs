using System;
using System.Data.SqlClient;
using System.Web;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        StatusLabel.Visible = false;
    }

    protected void SubmitRegistration(object sender, EventArgs e)
    {
        string username = UsernameField.Text.Trim();
        string password = PasswordField.Text.Trim();

        if (string.IsNullOrEmpty(username))
        {
            DisplayStatus("Username is required.", false);
            return;
        }

        if (string.IsNullOrEmpty(password) || !ValidatePassword(password))
        {
            DisplayStatus("Password must be at least 8 characters long.", false);
            return;
        }

        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            try
            {
                conn.Open();

                string checkIfExists = "SELECT COUNT(1) FROM Users WHERE Username = @Username";
                using (SqlCommand checkCmd = new SqlCommand(checkIfExists, conn))
                {
                    checkCmd.Parameters.AddWithValue("@Username", username);

                    int exists = Convert.ToInt32(checkCmd.ExecuteScalar());
                    if (exists > 0)
                    {
                        DisplayStatus("Username already exists.", false);
                        return;
                    }
                }

                string registerQuery = "INSERT INTO Users (Username, Password) VALUES (@Username, @Password)";
                using (SqlCommand registerCmd = new SqlCommand(registerQuery, conn))
                {
                    registerCmd.Parameters.AddWithValue("@Username", username);
                    registerCmd.Parameters.AddWithValue("@Password", password);

                    registerCmd.ExecuteNonQuery();
                    DisplayStatus("Registration successful!", true);

                    String routeUrl = VirtualPathUtility.ToAbsolute("~/login");
                    Response.Redirect(routeUrl);
                }
            }
            catch (Exception err)
            {
                DisplayStatus("Registration failed!", false);
                System.Diagnostics.Debug.WriteLine("Error: " + err.Message);
            }
        }
    }

    private void DisplayStatus(string message, bool isSuccess)
    {
        StatusLabel.Text = message;
        StatusLabel.CssClass = isSuccess ? "success-message" : "error-message";
        StatusLabel.Visible = true;
    }

    private bool ValidatePassword(string password)
    {
        return password.Length >= 8;
    }
}
