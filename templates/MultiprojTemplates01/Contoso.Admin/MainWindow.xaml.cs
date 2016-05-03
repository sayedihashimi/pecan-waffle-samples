using Contoso.Shared.Core;
using Contoso.Shared.Mobile;
using Contoso.Shared.Web;
using Contoso.Web.Admin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Contoso.Admin {
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window {
        public MainWindow() {
            InitializeComponent();
            System.Console.WriteLine(GetName());
        }

        public static string GetName() {
            return $"Wpf + {WebAdmin.GetName()} + {WebClass.GetName()} + {MobileClass.GetName()} + {CoreClass.GetName()}";
        }
    }
}
