using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Contoso.Web.External.Startup))]
namespace Contoso.Web.External
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
