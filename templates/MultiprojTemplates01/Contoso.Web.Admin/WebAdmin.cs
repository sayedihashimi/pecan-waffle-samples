using Contoso.Shared.Core;
using Contoso.Shared.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Contoso.Web.Admin
{
    public class WebAdmin
    {
        public static string GetName() {
            return $"WebAdmin + {WebClass.GetName()} + {CoreClass.GetName()}";
        }
    }
}
