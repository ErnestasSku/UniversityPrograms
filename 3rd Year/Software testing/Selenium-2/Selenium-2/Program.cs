// See https://aka.ms/new-console-template for more information
Console.WriteLine("Hello, World!");
var data = System.IO.File.ReadLines("C:\\Users\\ernes\\source\\repos\\Selenium-2\\Tests\\data1.txt").ToList();

List<int> a = new() { 1, 2, 3, 4 };
a = a.Select(x => x * 2).ToList();
//a.ForEach(s => Console.WriteLine(s));
a.ForEach(Console.Write);