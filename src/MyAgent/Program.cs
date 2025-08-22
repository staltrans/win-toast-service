using System;
using System.Windows.Forms;
using Microsoft.Toolkit.Uwp.Notifications; // NuGet Microsoft.Toolkit.Uwp.Notifications

namespace MyAgent
{
    static class Program
    {
        const string AppId = "staltrans.win-toast-service.agent";
        [STAThread]
        static void Main()
        {
            // Покажем простой Toast
            new ToastContentBuilder()
                .AddText("MyService Notification")
                .AddText("Событие от MyServiceApp (EventID=1001)")
                .Show(toast =>
                {
                    // Указываем AppUserModelID для совместимости с Win32 ярлыком
                    toast.Tag = "1001";
                });
        }
    }
}
