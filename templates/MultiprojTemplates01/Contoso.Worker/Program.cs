using Contoso.Shared.Mobile;
using Contoso.Web.Admin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Contoso.Worker {
    class Program {
        static void Main(string[] args) {
            System.Console.WriteLine(GetName());
        }

        static string GetName() {
            return $"Worker + {WebAdmin.GetName()} + {MobileClass.GetName()}";
        }
    }
}
