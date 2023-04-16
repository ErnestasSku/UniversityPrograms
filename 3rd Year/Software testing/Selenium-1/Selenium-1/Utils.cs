using OpenQA.Selenium;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Selenium_1
{
    public static class Utils
    {
        public static void ClickJs(this IWebElement element, IJavaScriptExecutor js)
        {
            js.ExecuteScript("arguments[0].click();", element);
        }
    }
}
