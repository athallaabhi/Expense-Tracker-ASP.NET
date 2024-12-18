<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Home.aspx.cs"
Inherits="_Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head runat="server">
    <title>Expenses Tracker</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio,line-clamp,container-queries"></script>
  </head>
  <body class="bg-gray-100 overflow-x-hidden">
    <form id="form1" runat="server">
      <div class="w-full h-20 bg-teal-600 px-6 flex justify-between items-center">
        <h2 class="font-bold text-xl text-white">Expenses Tracker</h2>
        <button onclick="toggleModal('logout'); event.preventDefault();" 
                class="px-4 py-2 rounded-md bg-teal-800 text-white font-medium hover:bg-teal-900 transition">
            Logout
        </button>
      </div>


      <div class="container mx-auto p-20">
        <div class="flex justify-center w-full">
            <asp:Label ID="HelloLabel" runat="server" Text="" CssClass="text-3xl font-bold mb-4"></asp:Label>
        </div>

         <div class="mt-4">
          <h3 class="text-2xl font-semibold text-center">Add Expense</h3>
          
          <div class="bg-white p-6 rounded-lg shadow-md mt-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label class="block text-gray-700">Expense Name:</label>
                  <asp:TextBox ID="NameTextBox" runat="server" CssClass="form-input w-full p-2 border rounded-md" placeholder="e.g., Grocery" />
                </div>
              <div>
                <label class="block text-gray-700">Category:</label>
                <asp:TextBox ID="CategoryTextBox" runat="server" CssClass="form-input w-full p-2 border rounded-md" placeholder="e.g., Food, Utilities" />
              </div>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
              <div>
                <label class="block text-gray-700">Amount (in Rupiah):</label>
                <asp:TextBox ID="AmountTextBox" runat="server" CssClass="form-input w-full p-2 border rounded-md" placeholder="e.g., 50000" />
              </div>
              <div>
                <label class="block text-gray-700">Date:</label>
                <asp:TextBox ID="DateTextBox" runat="server" TextMode="Date" CssClass="form-input w-full p-2 border rounded-md" />
              </div>
            </div>

            <div class="mt-4 flex justify-center">
              <button type="submit" runat="server" onserverclick="AddExpenseButton_Click" class="bg-teal-600 hover:bg-teal-700 text-white px-12 py-2 rounded-lg font-semibold">
                Add Expense
              </button>
            </div>
          </div>
        </div>

        <div class="space-y-4 mt-12">
        <h3 class="text-2xl font-semibold text-center">Your Expenses</h3>
          <asp:Repeater ID="ExpenseRepeater" runat="server">
            <ItemTemplate>
                <div class="bg-white p-4 rounded-lg shadow-md mb-4">
                    <div class="flex justify-between items-center">
                        <div>
                            <div class="text-lg font-semibold"><%# Eval("Name") %></div>
                            <div class="text-sm text-gray-600">Category: <%# Eval("Category") %></div>
                        </div>
                        <div>
                            <button
                                onclick="openEditModal('<%# Eval("ID") %>', '<%# Eval("Name") %>', '<%# Eval("Category") %>', '<%# Eval("Amount") %>', '<%# Eval("Date") %>'); event.preventDefault();"
                                class="bg-teal-600 hover:bg-teal-700 text-white px-6 py-2 font-medium rounded-md">
                                Edit
                            </button>
                            <button
                                onclick="openDeleteModal('<%# Eval("ID") %>'); event.preventDefault();"
                                class="bg-red-600 hover:bg-red-800 text-white px-6 py-2 font-medium ml-4 rounded-md">
                                Delete
                            </button>
                        </div>
                    </div>
                    <div class="mt-2 flex justify-between">
                        <div class="text-sm text-gray-600">Time: <%# Eval("Date") %></div>
                        <div class="text-lg font-semibold text-neutral-900">Rp <%# Eval("Amount") %></div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        </div>

        <div id="editExpense" class="fixed inset-0 bg-neutral-700 bg-opacity-70 hidden flex items-center justify-center z-50">
            <div class="bg-white p-10 rounded-lg shadow-lg max-w-lg w-full">
                <div class="flex justify-center items-center mb-6">
                    <h3 class="text-2xl font-semibold text-teal-700">Edit Expense</h3>
                </div>
                <div class="space-y-6">
                    <asp:TextBox
                        ID="EditFieldID"
                        runat="server"
                        CssClass="hidden"></asp:TextBox>
                    <asp:TextBox
                        ID="EditFieldName"
                        runat="server"
                        placeholder="Expense Name"
                        CssClass="form-input w-full p-4 mb-4 border-2 border-teal-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-teal-500"></asp:TextBox>
                    <asp:TextBox
                        ID="EditFieldCategory"
                        runat="server"
                        placeholder="Category"
                        CssClass="form-input w-full p-4 mb-4 border-2 border-teal-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-teal-500"></asp:TextBox>
                    <asp:TextBox
                        ID="EditFieldAmount"
                        runat="server"
                        placeholder="Amount"
                        CssClass="form-input w-full p-4 mb-4 border-2 border-teal-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-teal-500"></asp:TextBox>
                    <asp:TextBox
                        ID="EditFieldDate"
                        runat="server"
                        TextMode="Date"
                        CssClass="form-input w-full p-4 mb-4 border-2 border-teal-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-teal-500"></asp:TextBox>

                    <div class="flex justify-end gap-4">
                        <button type="submit" runat="server" onserverclick="EditExpenses" class="bg-teal-500 hover:bg-teal-600 px-4 py-3 text-white font-semibold rounded-lg shadow-md focus:outline-none focus:ring-2 focus:ring-teal-500">
                            Cancel
                        </button>
                        <button type="submit" runat="server" onserverclick="EditExpenses" class="bg-teal-700 hover:bg-teal-800 px-4 py-3 text-white font-semibold rounded-lg shadow-md focus:outline-none focus:ring-2 focus:ring-teal-500">
                            Edit Expenses
                        </button>
                    </div>
                </div>
            </div>
        </div>



        <div id="deleteExpense" class="fixed inset-0 bg-neutral-700 bg-opacity-70 hidden flex items-center justify-center z-50">
            <div class="bg-white p-8 rounded-lg max-w-sm w-full shadow-lg">
                <div class="flex justify-center items-center mb-6">
                    <h3 class="text-2xl font-semibold text-teal-700">Delete Expense</h3>
                </div>

                <div class="mt-4 text-gray-800">
                    <p class="text-lg">Are you sure you want to delete this expense?</p>
                </div>

                <div class="mt-8 flex justify-end gap-6">
                    <asp:TextBox ID="DeleteID" runat="server" CssClass="hidden"></asp:TextBox>
                    <button class="bg-teal-500 text-white py-2 px-5 rounded-md hover:bg-teal-600 transition duration-200" onclick="exitModal('confirmDeleteModal')">
                        Cancel
                    </button>
                    <button class="bg-red-500 text-white py-2 px-5 rounded-md hover:bg-red-600 transition duration-200" runat="server" onserverclick="DeleteExpenses">
                        Delete
                    </button>
                </div>
            </div>
        </div>


        <div id="logout" class="fixed inset-0 bg-neutral-700 bg-opacity-70 hidden flex items-center justify-center z-50">
            <div class="bg-white p-8 rounded-lg max-w-sm w-full shadow-lg">
                <div class="flex justify-center items-center mb-6">
                    <h3 class="text-2xl font-semibold text-teal-700">Logout</h3>
                </div>

                <div class="mt-4 text-gray-800">
                    <p class="text-lg">Are you sure you want to logout?</p>
                </div>

                <div class="mt-8 flex justify-end gap-6">
                    <asp:TextBox ID="TextBox1" runat="server" CssClass="hidden"></asp:TextBox>
                    <button class="bg-teal-500 text-white py-2 px-5 rounded-md hover:bg-teal-600 transition duration-200" onclick="exitModal('logoutModal')">
                        Cancel
                    </button>
                    <button class="bg-red-500 text-white py-2 px-5 rounded-md hover:bg-red-600 transition duration-200" runat="server" onserverclick="LogoutButton_Click">
                        Logout
                    </button>
                </div>
            </div>
        </div>

      </div>
    </form>
    

    <script>
        function formatToDate(dateString) {
            const parts = dateString.split(' ')[0].split('/');
            return `${parts[2]}-${parts[1]}-${parts[0]}`;
        }

      function toggleModal(idModal) {
        document.getElementById(idModal).classList.remove("hidden");
        }

        function exitModal(idModal) {
            document.getElementById(idModal).classList.add("hidden");
        }

        function openEditModal(id, name, category, amount, date) {
            document.getElementById('<%= EditFieldID.ClientID %>').value = id;
            document.getElementById('<%= EditFieldName.ClientID %>').value = name;
            document.getElementById('<%= EditFieldCategory.ClientID %>').value = category;
            document.getElementById('<%= EditFieldAmount.ClientID %>').value = amount;
            document.getElementById('<%= EditFieldDate.ClientID %>').value = formatToDate(date);

            event.preventDefault();
            document.getElementById('editExpense').classList.remove('hidden');
            
        }

        function openDeleteModal(id) {
            document.getElementById('<%= DeleteID.ClientID %>').value = id;
            document.getElementById('deleteExpense').classList.remove('hidden');
        }

    </script>
  </body>
</html>
