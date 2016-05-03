using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Contoso.Web.Internal.Startup))]
namespace Contoso.Web.Internal
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
