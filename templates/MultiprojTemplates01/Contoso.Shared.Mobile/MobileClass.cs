using Contoso.Shared.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Contoso.Shared.Mobile
{
    public class MobileClass
    {
        public static string GetName() {
            return $"Mobile + {CoreClass.GetName()}";
        }
    }
}
