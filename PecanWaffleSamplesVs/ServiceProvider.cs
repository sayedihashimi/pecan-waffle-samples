using System;
using System.Collections.Generic;
#if NET451
using System.ComponentModel;
#endif
using System.Linq;
using System.Reflection;

namespace PecanWaffleSamplesVs {
    internal class ServiceProvider : IServiceProvider {
        private readonly Dictionary<Type, object> _instances = new Dictionary<Type, object>();
        private readonly IServiceProvider _fallbackServiceProvider;

        public ServiceProvider() {
            _instances[typeof(IServiceProvider)] = this;
        }

        public ServiceProvider(IServiceProvider fallbackServiceProvider)
            : this() {
            _fallbackServiceProvider = fallbackServiceProvider;
        }

        public void Add(Type type, object instance) {
            _instances[type] = instance;
        }

        public void Add<T>(object instance) {
            _instances[typeof(T)] = instance;
        }

        public object GetService(Type serviceType) {
            object instance;
            if (_instances.TryGetValue(serviceType, out instance)) {
                return instance;
            }

            if (_fallbackServiceProvider != null) {
                return _fallbackServiceProvider.GetService(serviceType);
            }

            return null;
        }
    }
}
