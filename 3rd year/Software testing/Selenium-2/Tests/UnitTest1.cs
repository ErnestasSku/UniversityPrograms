using OpenQA.Selenium;
using OpenQA.Selenium.Remote;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using SeleniumExtras.WaitHelpers;

namespace Tests
{
    public class Tests
    {

        string Name;
        string LastName;
        string Email;
        string Password;

        IWebDriver Driver;

        [OneTimeSetUp]
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
            Password = new RandomString()
                .AddAlphaNumeric(10)
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
            driver.FindElement(By.XPath("//input[@id='Password']")).SendKeys(Password);
            driver.FindElement(By.XPath("//input[@id='ConfirmPassword' ]")).SendKeys(Password);
            driver.FindElement(By.XPath("//input[@id='register-button']")).Click();
            driver.FindElement(By.XPath("//input[@value='Continue']")).Click();
            driver.Quit();
        }

        [SetUp]
        public void Setup()
        {
            Driver = new RemoteWebDriver(new Uri("http://localhost:4444/wd/hub"), options: new ChromeOptions());
            //Driver = new ChromeDriver();
            Driver.Manage().Window.Maximize();
            //Driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(5);
            //Driver.Manage().Timeouts()
        }

        [TearDown]
        public void TearDown()
        {
            Driver.Quit();
        }

        [Test]
        public void Test1()
        {
            Driver.Navigate().GoToUrl("https://demowebshop.tricentis.com/");
            Driver.FindElement(By.XPath("//a[text()='Log in']")).Click();
            Driver.FindElement(By.XPath("//input[@id='Email']")).SendKeys(Email);
            Driver.FindElement(By.XPath("//input[@id='Password']")).SendKeys(Password);
            Driver.FindElement(By.XPath("//input[@value='Log in']")).Click();
            Driver.FindElement(By.XPath("//a[@href='/digital-downloads']")).Click();

            var data = File.ReadLines("C:\\Users\\ernes\\source\\repos\\Selenium-2\\Tests\\data1.txt").ToList<string>();
            data.ForEach(data =>
            {
                Driver.FindElement(By.XPath($"//a[text()='{data}']/following::input[@value='Add to cart']")).Click();
                var wait = new WebDriverWait(Driver, TimeSpan.FromSeconds(5))
                   .Until(ExpectedConditions.ElementExists(By.XPath("//div[@id='bar-notification']")));
                new WebDriverWait(Driver, TimeSpan.FromSeconds(10))
                    .Until(ExpectedConditions.ElementToBeClickable(By.XPath("//span[@class='close']"))).Click();
                new WebDriverWait(Driver, TimeSpan.FromSeconds(5))
                    .Until(ExpectedConditions.ElementExists(By.XPath("//div[@id='bar-notification' and @style='display: none;']")));
            });
            Driver.FindElement(By.XPath("//a[@class='ico-cart']")).Click();

            Driver.FindElement(By.XPath("//input[@id='termsofservice']")).Click();
            Driver.FindElement(By.XPath("//button[@id='checkout']")).Click();

            try
            {
                Driver.FindElement(By.XPath("//select[@id='billing_address_id']"));
            } catch (Exception ex)
            {
                FillOutBilling(Driver);
            }

            new WebDriverWait(Driver, TimeSpan.FromSeconds(3))
                .Until(ExpectedConditions.ElementToBeClickable(By.XPath("//input[@class='button-1 new-address-next-step-button']")))
                .Click();
            new WebDriverWait(Driver, TimeSpan.FromSeconds(3))
                .Until(ExpectedConditions.ElementToBeClickable(By.XPath("//input[@class='button-1 payment-method-next-step-button']")))
                .Click();
            new WebDriverWait(Driver, TimeSpan.FromSeconds(3))
                .Until(ExpectedConditions.ElementToBeClickable(By.XPath("//input[@class='button-1 payment-info-next-step-button']")))
                .Click();
            new WebDriverWait(Driver, TimeSpan.FromSeconds(3))
                .Until(ExpectedConditions.ElementToBeClickable(By.XPath("//input[@class='button-1 confirm-order-next-step-button']")))
                .Click();

            Assert.True(Driver.FindElement(By.XPath("//strong[text()='Your order has been successfully processed!']")) != null);
        }

        [Test]
        public void Test2()
        {
            Driver.Navigate().GoToUrl("https://demowebshop.tricentis.com/");
            Driver.FindElement(By.XPath("//a[text()='Log in']")).Click();
            Driver.FindElement(By.XPath("//input[@id='Email']")).SendKeys(Email);
            Driver.FindElement(By.XPath("//input[@id='Password']")).SendKeys(Password);
            Driver.FindElement(By.XPath("//input[@value='Log in']")).Click();
            Driver.FindElement(By.XPath("//a[@href='/digital-downloads']")).Click();

            var data = File.ReadLines("C:\\Users\\ernes\\source\\repos\\Selenium-2\\Tests\\data2.txt").ToList<string>();

            data.ForEach(data =>
            {
                Driver.FindElement(By.XPath($"//a[text()='{data}']/following::input[@value='Add to cart']")).Click();
                var wait = new WebDriverWait(Driver, TimeSpan.FromSeconds(5))
                   .Until(ExpectedConditions.ElementExists(By.XPath("//div[@id='bar-notification']")));
                new WebDriverWait(Driver, TimeSpan.FromSeconds(5))
                    .Until(ExpectedConditions.ElementExists(By.XPath("//span[@class='close']"))).Click();
                new WebDriverWait(Driver, TimeSpan.FromSeconds(5))
                    .Until(ExpectedConditions.ElementExists(By.XPath("//div[@id='bar-notification' and @style='display: none;']")));
                
            });
            Driver.FindElement(By.XPath("//a[@class='ico-cart']")).Click();

            Driver.FindElement(By.XPath("//input[@id='termsofservice']")).Click();
            Driver.FindElement(By.XPath("//button[@id='checkout']")).Click();

            try
            {
                Driver.FindElement(By.XPath("//select[@id='billing-address-select']"));
            }
            catch (Exception ex)
            {
                FillOutBilling(Driver);
            }


            new WebDriverWait(Driver, TimeSpan.FromSeconds(3))
                .Until(ExpectedConditions.ElementToBeClickable(By.XPath("//input[@class='button-1 new-address-next-step-button']")))
                .Click();
            new WebDriverWait(Driver, TimeSpan.FromSeconds(3))
                .Until(ExpectedConditions.ElementToBeClickable(By.XPath("//input[@class='button-1 payment-method-next-step-button']")))
                .Click();
            new WebDriverWait(Driver, TimeSpan.FromSeconds(3))
                .Until(ExpectedConditions.ElementToBeClickable(By.XPath("//input[@class='button-1 payment-info-next-step-button']")))
                .Click();
            new WebDriverWait(Driver, TimeSpan.FromSeconds(3))
                .Until(ExpectedConditions.ElementToBeClickable(By.XPath("//input[@class='button-1 confirm-order-next-step-button']")))
                .Click();


            Assert.True(Driver.FindElement(By.XPath("//strong[text()='Your order has been successfully processed!']")) != null);
        }

        public static void FillOutBilling(IWebDriver Driver)
        {
            SelectElement countries = new SelectElement(Driver.FindElement(By.XPath("//select[@id='BillingNewAddress_CountryId']")));
            countries.SelectByText("Lithuania");
            Driver.FindElement(By.XPath("//input[@id='BillingNewAddress_City']")).SendKeys("Vilnius");
            Driver.FindElement(By.XPath("//input[@id='BillingNewAddress_Address1']")).SendKeys("Konstitucijis prospektas");
            Driver.FindElement(By.XPath("//input[@id='BillingNewAddress_ZipPostalCode']")).SendKeys("24561");
            Driver.FindElement(By.XPath("//input[@id='BillingNewAddress_PhoneNumber']")).SendKeys("+37011001111");
        }
    }
}