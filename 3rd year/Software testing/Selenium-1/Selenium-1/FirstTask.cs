using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Selenium_1
{
    public class FirstTask
    {
        public static void Run()
        {

            var driver = new ChromeDriver();
            driver.Navigate().GoToUrl("https://demowebshop.tricentis.com/");
            driver.Manage().Window.Maximize();


            driver.FindElement(By.XPath("//a[text()='Log in']")).Click();
            driver.FindElement(By.XPath("//input[@value='Register']")).Click();
            driver.FindElement(By.XPath("//input[@id='gender-male']")).Click();
            driver.FindElement(By.XPath("//input[@id='FirstName']")).SendKeys("Alfredas");
            driver.FindElement(By.XPath("//input[@id='LastName']")).SendKeys("Bosas");

            var dummyEmail = Guid.NewGuid().ToString() + "@gmail.com";
            driver.FindElement(By.XPath("//input[@id='Email']")).SendKeys(dummyEmail);
            driver.FindElement(By.XPath("//input[@id='Password']")).SendKeys("DificultPassword1!");
            driver.FindElement(By.XPath("//input[@id='ConfirmPassword' ]")).SendKeys("DificultPassword1!");
            driver.FindElement(By.XPath("//input[@id='register-button']")).Click();
            driver.FindElement(By.XPath("//input[@value='Continue']")).Click();
            driver.FindElement(By.XPath("//a[@href='/computers']")).Click();
            driver.FindElement(By.XPath("//h2/a[@href='/desktops']")).Click();
            driver.FindElement(By.XPath("//span[@class='price actual-price' and text() > '1500.00']/parent::div/following-sibling::div/input")).Click();


            Thread.Sleep(2000);
            driver.FindElement(By.XPath("// input[@value='Add to cart']")).Click();
            Thread.Sleep(1000);
            driver.FindElement(By.XPath("//span[@class='close']")).Click();
            Thread.Sleep(1000);
            driver.FindElement(By.XPath("//a[@class='ico-cart']")).Click();
            driver.FindElement(By.XPath("//input[@name='removefromcart']")).Click();
            driver.FindElement(By.XPath("//input[@name='updatecart']")).Click();
            var orderText = driver.FindElement(By.XPath("//div[@class='order-summary-content']")).Text;

            if (orderText.Contains("Your Shopping Cart is empty!"))
            {
                Console.WriteLine("Cart is empty");
            }
            else
            {
                Console.WriteLine("Cart is not empty");
            }


            Thread.Sleep(3000);
            driver.Quit();
        }
    }
}
