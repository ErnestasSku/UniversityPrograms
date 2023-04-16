using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tests
{
    public class RandomString
    {
        const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const string nums = "0123456789";

        Random random;
        private string _randomString;

        public RandomString()
        {
            random = new Random();
            _randomString = string.Empty;
        }

        public RandomString AddLetters(int number)
        {
            _randomString += (add(chars, number));
            return this;
        }

        public RandomString AddLettersRange(int low, int high)
        {
            int number = new Random().Next(low, high);
            _randomString += (add(chars, number));
            return this;
        }

        public RandomString AddAlphaNumeric(int num)
        {
            _randomString += (add(chars + nums, num));
            return this;
        }

        public RandomString AddCharacterDirectly(char c)
        {
            _randomString += c;
            return this;
        }

        public RandomString AddNumbers(int number)
        {
            _randomString += (add(nums, number));
            return this;
        }

        public RandomString AddNumbersRange(int low, int high)
        {
            int number = new Random().Next(low, high);
            _randomString += (add(nums, number));
            return this;
        }

        private string add(string c, int number)
        {
            return new string(Enumerable.Repeat(c, number)
                .Select(s => s[random.Next(s.Length)])
                .ToArray());
        }

        public string String()
        {
            return _randomString;
        }
    }
}
