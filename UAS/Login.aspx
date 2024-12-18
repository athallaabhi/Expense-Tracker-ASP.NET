<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio,line-clamp,container-queries"></script>
</head>
<body class="bg-neutral-800 h-screen flex items-center justify-center">
    <form id="form1" runat="server" class="bg-neutral-900 p-8 rounded-2xl shadow-2xl w-full max-w-md">
        <h2 class="text-3xl font-semibold text-center text-white mb-6">Login</h2>

        <asp:Label ID="StatusLabel" runat="server" CssClass="text-red-500 mb-4 block" Text="" Visible="false"></asp:Label>

        <div class="mb-6">
            <label for="UsernameField" class="block text-white font-medium text-lg mb-2">Username</label>
            <asp:TextBox ID="UsernameField" runat="server" placeholder="Enter your username" 
                CssClass="w-full p-4 border-2 border-teal-500 rounded-lg focus:outline-none focus:ring-2 focus:ring-teal-600 transition-all duration-300" required />
        </div>

        <div class="mb-6">
            <label for="PasswordField" class="block text-white font-medium text-lg mb-2">Password</label>
            <asp:TextBox ID="PasswordField" runat="server" TextMode="Password" placeholder="Enter your password" 
                CssClass="w-full p-4 border-2 border-teal-500 rounded-lg focus:outline-none focus:ring-2 focus:ring-teal-600 transition-all duration-300" required />
        </div>

        <div class="flex justify-center">
            <asp:Button ID="LoginButton" runat="server" Text="Login" OnClick="SubmitLogin" 
                CssClass="w-full py-3 bg-teal-600 text-white rounded-lg hover:bg-teal-700 focus:outline-none focus:ring-2 focus:ring-teal-600 transition-all duration-300" />
        </div>

        <div class="mt-6 text-center">
            <span class="text-white text-sm">Don't have an account? </span>
            <a href="/register" class="text-teal-400 hover:text-teal-500 font-semibold">Register here</a>
        </div>
    </form>
</body>
</html>
