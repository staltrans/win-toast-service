using System;
using System.Diagnostics;
using System.Timers;

namespace MyService
{
    class Program
    {
        static EventLog ev;
        static Timer timer;
        static void Main(string[] args)
        {
            const string source = "MyServiceApp";
            const string logName = "Application";
            if (!EventLog.SourceExists(source))
                EventLog.CreateEventSource(source, logName);
            ev = new EventLog { Source = source, Log = logName };
            // Для демонстрации — пишем событие каждые 60 секунд
            timer = new Timer(60000);
            timer.Elapsed += (s,e) => WriteEvent();
            timer.Start();
            Console.WriteLine("Service loop running. Press Enter to exit.");
            Console.ReadLine();
        }
        static void WriteEvent()
        {
            ev.WriteEntry("Trigger toast", EventLogEntryType.Information, 1001);
            Console.WriteLine("Wrote event 1001");
        }
    }
}
