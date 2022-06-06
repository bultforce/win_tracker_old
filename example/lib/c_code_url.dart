// public static string GetUrl(string browser, Process p)
// {
//   string urldata = "";
//   try
//   {
//     AutomationElement root = AutomationElement.FromHandle(p.MainWindowHandle);
//     var SearchBar = root.FindFirst(TreeScope.Descendants, new PropertyCondition(AutomationElement.NameProperty, "Address and search bar"));
//
//     if (SearchBar != null)
//     {
//       string str = (string)SearchBar.GetCurrentPropertyValue(ValuePatternIdentifiers.ValueProperty);
//       if (!string.IsNullOrEmpty(str))
//       {
//         if (!str.StartsWith("http"))
//         {
//           urldata = "http://" + str;
//         }
//         else
//         {
//           urldata = str;
//         }
//       }
//       // LogFile.LogFileWrite("chrome browser    ===" + urldata,"AppAndUrlLog");
//       return urldata;
//
//     }
//   }
//   catch (Exception ex)
//   {
//   //LogFile.ErrorLog(ex);
//   ErrorLog(ex);
//   }
//   return urldata;
// }