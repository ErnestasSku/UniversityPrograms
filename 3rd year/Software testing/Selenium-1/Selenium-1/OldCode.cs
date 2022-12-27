using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.DevTools;

namespace Selenium_1
{
    internal class OldCode
    {
        public void a()
        {
            var driver = new ChromeDriver();
            driver.Navigate().GoToUrl("https://google.com/");
            //driver.Navigate().GoToUrl("https://duckduckgo.com/");
            //((IJavaScriptExecutor)driver).ExecuteScript("window.open()");
            driver.Manage().Window.Maximize();
            driver.FindElement(By.XPath("//*[@id=\"L2AGLb\"]/div")).Click();
            driver.FindElement(By.XPath("/html/body/div[1]/div[3]/form/div[1]/div[1]/div[1]/div/div[2]/input")).SendKeys("Test Automation");
            driver.FindElement(By.XPath("/html/body/div[1]/div[3]/form/div[1]/div[1]/div[1]/div/div[2]/input")).SendKeys(Keys.Enter);
            driver.FindElement(By.XPath("//h3[text()='Test automation - Wikipedia']")).Click();
        }

    }
}
