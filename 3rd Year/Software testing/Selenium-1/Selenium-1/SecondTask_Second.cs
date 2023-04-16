using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Selenium_1
{
    public class SecondTask_Second
    {

        static Func<ChromeDriver, bool> secondPage = driver => driver.FindElement(By.XPath("//button[text()='Next']")).Enabled;

        public static void Run()
        {
            var driver = new ChromeDriver();
            var js = (IJavaScriptExecutor)driver;
            driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(3);
            driver.Navigate().GoToUrl("https://demoqa.com/");
            driver.Manage().Window.Maximize();
            driver.FindElement(By.XPath("//h5[text()='Elements']")).ClickJs(js);
            driver.FindElement(By.XPath("//span[text()='Web Tables']")).ClickJs(js);

            while (!secondPage(driver))
            {
                var name = new RandomString()
                    .AddLettersRange(4, 9)
                    .String();
                var lastName = new RandomString()
                    .AddLettersRange(4, 9)
                    .String();
                var email = new RandomString()
                    .AddLettersRange(4, 8)
                    .AddCharacterDirectly('@')
                    .AddLettersRange(3, 7)
                    .AddCharacterDirectly('.')
                    .AddLettersRange(2, 3)
                    .String();
                var age = new RandomString()
                    .AddNumbersRange(1, 3)
                    .String();
                var salary = new RandomString()
                    .AddNumbersRange(4, 7)
                    .String();
                var deparment = new RandomString()
                    .AddLettersRange(4, 6)
                    .String();

                driver.FindElement(By.XPath("//button[text()='Add']")).Click();
                driver.FindElement(By.XPath("//input[@id='firstName']")).SendKeys(name);
                driver.FindElement(By.XPath("//input[@id='lastName']")).SendKeys(lastName);
                driver.FindElement(By.XPath("//input[@id='userEmail']")).SendKeys(email);
                driver.FindElement(By.XPath("//input[@id='age']")).SendKeys(age);
                driver.FindElement(By.XPath("//input[@id='salary']")).SendKeys(salary);
                driver.FindElement(By.XPath("//input[@id='department']")).SendKeys(deparment);
                driver.FindElement(By.XPath("//button[text()='Submit']")).Click();
            }

            driver.FindElement(By.XPath("//button[text()='Next']")).ClickJs(js);
            driver.FindElement(By.XPath("//span[@title='Delete']")).Click();

            if(!secondPage(driver))
            {
                js.ExecuteScript("alert('First page')");
            } else
            {
                js.ExecuteScript("alert('Failure')");
            }

            Thread.Sleep(5000);
            driver.Quit();
            
        }   
    }
}
