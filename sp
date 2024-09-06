using System;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    private static readonly string fileName = "log.txt";
    private static readonly object lockObject = new object();

    static void Main(string[] args)
    {
        while (true)
        {
            Console.WriteLine("1. Создать файл и записать данные");
            Console.WriteLine("2. Прочитать данные из файла");
            Console.WriteLine("3. Записать данные параллельно через потоки");
            Console.WriteLine("4. Удалить файл");
            Console.WriteLine("5. Выход");
            Console.Write("Введите номер команды: ");

            if (int.TryParse(Console.ReadLine(), out int command))
            {
                switch (command)
                {
                    case 1:
                        CreateAndWriteToFile();
                        break;
                    case 2:
                        ReadFromFile();
                        break;
                    case 3:
                        ParallelWriteToFile();
                        break;
                    case 4:
                        DeleteFile();
                        break;
                    case 5:
                        Console.WriteLine("Выход из программы.");
                        return;
                    default:
                        Console.WriteLine("Некорректный ввод. Попробуйте снова.");
                        break;
                }
            }
            else
            {
                Console.WriteLine("Некорректный ввод. Попробуйте снова.");
            }
        }
    }

    private static void CreateAndWriteToFile()
    {
        try
        {
            using (StreamWriter writer = new StreamWriter(fileName))
            {
                for (int i = 0; i < 10; i++)
                {
                    writer.WriteLine($"Запись {i + 1}: {DateTime.Now}");
                }
            }
            Console.WriteLine("Файл создан и данные записаны.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Ошибка при создании файла: {ex.Message}");
        }
    }

    private static void ReadFromFile()
    {
        try
        {
            if (File.Exists(fileName))
            {
                string content = File.ReadAllText(fileName);
                Console.WriteLine("Содержимое файла:");
                Console.WriteLine(content);
            }
            else
            {
                Console.WriteLine("Файл не существует.");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Ошибка при чтении файла: {ex.Message}");
        }
    }

    private static void ParallelWriteToFile()
    {
        try
        {
            Task[] tasks = new Task[2];

            for (int i = 0; i < 2; i++)
            {
                int threadNumber = i + 1;
                tasks[i] = Task.Run(() => WriteToFile(threadNumber));
            }

            Task.WaitAll(tasks);
            Console.WriteLine("Параллельная запись завершена.");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Ошибка при параллельной записи: {ex.Message}");
        }
    }

    private static void WriteToFile(int threadNumber)
    {
        for (int i = 0; i < 5; i++)
        {
            lock (lockObject)
            {
                using (StreamWriter writer = new StreamWriter(fileName, true))
                {
                    writer.WriteLine($"Поток {threadNumber}: Запись выполнена в {DateTime.Now}");
                }
                Thread.Sleep(100); // Задержка для демонстрации параллельности
            }
        }
    }

    private static void DeleteFile()
    {
        try
        {
            if (File.Exists(fileName))
            {
                File.Delete(fileName);
                Console.WriteLine("Файл удален.");
            }
            else
            {
                Console.WriteLine("Файл не существует.");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Ошибка при удалении файла: {ex.Message}");
        }
    }
}
