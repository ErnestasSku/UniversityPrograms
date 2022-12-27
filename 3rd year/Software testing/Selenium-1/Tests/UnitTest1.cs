using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using Selenium_1;

namespace Tests
{
    [SetUpFixture]
    public class Tests
    {
        string Name;
        string LastName;
        string Email;

        ChromeDriver Driver;


        //[OneTimeSetUp]
        public void CreateAccount()
        {
            Name = new RandomString()
                .AddLettersRange(4, 9)
                .String();
            LastName = new RandomString()
                .AddLettersRange(4, 9)
                .String();
            Email = new RandomString()
                .AddLettersRange(4, 8)
                .AddCharacterDirectly('@')
                .AddLettersRange(3, 7)
                .AddCharacterDirectly('.')
                .AddLettersRange(2, 3)
                .String();

            var driver = new ChromeDriver();
            driver.Navigate().GoToUrl("https://demowebshop.tricentis.com/");
            driver.Manage().Window.Maximize();


            driver.FindElement(By.XPath("//a[text()='Log in']")).Click();
            driver.FindElement(By.XPath("//input[@value='Register']")).Click();
            driver.FindElement(By.XPath("//input[@id='gender-male']")).Click();
            driver.FindElement(By.XPath("//input[@id='FirstName']")).SendKeys(Name);
            driver.FindElement(By.XPath("//input[@id='LastName']")).SendKeys(LastName);

            driver.FindElement(By.XPath("//input[@id='Email']")).SendKeys(Email);
            driver.FindElement(By.XPath("//input[@id='Password']")).SendKeys("DificultPassword1!");
            driver.FindElement(By.XPath("//input[@id='ConfirmPassword' ]")).SendKeys("DificultPassword1!");
            driver.FindElement(By.XPath("//input[@id='register-button']")).Click();
            driver.FindElement(By.XPath("//input[@value='Continue']")).Click();
            driver.Quit();
        }

        [SetUp]
        public void Setup()
        {
            Driver = new ChromeDriver();
        }

        [TearDown]
        public void TearDown()
        {
            Driver.Quit();
        }

        [Test]
        public void Test1()
        {
            List<string> data = new() { "3rd Album", "3rd Album" };


            Assert.Pass();
        }

        [Test]
        public void Test2()
        {

        }
    }
}