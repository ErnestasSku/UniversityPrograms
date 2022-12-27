using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using SeleniumExtras.WaitHelpers;
using System.Linq;

namespace Selenium_1
{
    public class SecondTask_First
    {
        public static void Run()
        {

            var driver = new ChromeDriver();
            var js = (IJavaScriptExecutor)driver;
            driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(5);
            driver.Navigate().GoToUrl("https://demoqa.com/");
            driver.Manage().Window.Maximize();
            driver.FindElement(By.XPath("//h5[text()='Widgets']")).ClickJs(js);
            driver.FindElement(By.XPath("//span[text()='Progress Bar']")).ClickJs(js);
            driver.FindElement(By.XPath("//Button[text()='Start']")).ClickJs(js);
            new WebDriverWait(driver, TimeSpan.FromSeconds(30))
                .Until(ExpectedConditions.ElementExists(By.XPath("//div[text()='100%']")));
            driver.FindElement(By.XPath("//button[text()='Reset']")).Click();

            var check = new WebDriverWait(driver, TimeSpan.FromSeconds(5))
                .Until(ExpectedConditions.ElementExists(By.XPath("//div[text()='0%']"))).Text.Equals("0%");

            Console.WriteLine(check);
            if (check)
            {
                js.ExecuteScript("alert('It is 0%');", Enumerable.Empty<object>());
            }
            else
            {
                js.ExecuteScript("alert('It not is 0%');", Enumerable.Empty<object>());

            }

            Thread.Sleep(5000);
            driver.Quit();
        }
    }
}
