using Ap.Business.Domains;

namespace Vivablast.App_Start
{
    using Autofac;
    using Autofac.Integration.Mvc;
    using System.Reflection;
    using System.Web.Mvc;

    using Ap.Data.Repositories;
    using Ap.Data.Seedworks;
    //using Repositories;
    //using Repositories.Interfaces;

    public class IocConfig
    {
        public static void RegisterDependencies()
        {
            var builder = new ContainerBuilder();
            builder.RegisterControllers(typeof(MvcApplication).Assembly);

            // database
            builder.RegisterType<DatabaseFactory>().As<IDatabaseFactory>();

            // data
            builder.RegisterType<ApContext>().As<IDbContext>().InstancePerHttpRequest();
            builder.RegisterType<UnitOfWork>().As<IUnitOfWork>().InstancePerHttpRequest();

            builder.RegisterGeneric(typeof(Repository<>))
                .As(typeof(IRepository<>))
                .InstancePerHttpRequest();

            builder.RegisterAssemblyTypes(Assembly.Load("Ap.Business"))
                .Where(t => t.Name.EndsWith("Repository"))
                .AsImplementedInterfaces()
                .InstancePerHttpRequest();

            builder.RegisterAssemblyTypes(Assembly.Load("Ap.Service"))
                .Where(t => t.Name.EndsWith("Service"))
                .AsImplementedInterfaces()
                .InstancePerHttpRequest()
                .PropertiesAutowired(PropertyWiringOptions.AllowCircularDependencies);

            builder.RegisterModule<AutofacWebTypesModule>();
            builder.RegisterFilterProvider();

            //builder.RegisterType<StockRepository>()
            //    .As<IStockRepository>()
            //    .InstancePerHttpRequest();

            //builder.RegisterType<UserRepository>()
            //    .As<IUserRepository>()
            //    .InstancePerHttpRequest();

            //builder.RegisterType<UserFunctionRepository>()
            //    .As<IUserFunctionRepository>()
            //    .InstancePerHttpRequest();

            //builder.RegisterType<StoreRepository>()
            //    .As<IStoreRepository>()
            //    .InstancePerHttpRequest();

            //builder.RegisterType<ProjectRepository>()
            //    .As<IProjectRepository>()
            //    .InstancePerHttpRequest();

            //builder.RegisterType<SupplierRepository>()
            //   .As<ISupplierRepository>()
            //   .InstancePerHttpRequest();

            //builder.RegisterType<ProductRepository>()
            //   .As<IProductRepository>()
            //   .InstancePerHttpRequest();

            //builder.RegisterType<RequisitionRepository>()
            //  .As<IRequisitionRepository>()
            //  .InstancePerHttpRequest();

            //builder.RegisterType<RequisitionDetailRepository>()
            //  .As<IRequisitionDetailRepository>()
            //  .InstancePerHttpRequest();

            //builder.RegisterType<PORepository>()
            //   .As<IPORepository>()
            //   .InstancePerHttpRequest();

            //builder.RegisterType<PODetailRepository>()
            //   .As<IPODetailRepository>()
            //   .InstancePerHttpRequest();

            //builder.RegisterType<PriceRepository>()
            //   .As<IPriceRepository>()
            //   .InstancePerHttpRequest();

            //builder.RegisterType<ReturnRepository>()
            //   .As<IReturnRepository>()
            //   .InstancePerHttpRequest();

            //builder.RegisterType<AssignRepository>()
            //   .As<IAssignRepository>()
            //   .InstancePerHttpRequest();

            //builder.RegisterType<FulfillmentRepository>()
            //   .As<IFulfillmentRepository>()
            //   .InstancePerHttpRequest();

            //builder.RegisterType<AssignRepository>()
            //   .As<IAssignRepository>()
            //   .InstancePerHttpRequest();

            //builder.RegisterType<AccountingRepository>()
            //   .As<IAccountingRepository>()
            //   .InstancePerHttpRequest();

            //builder.RegisterType<Stock_PictureRepository>()
            //   .As<IStock_PictureRepository>()
            //   .InstancePerHttpRequest();

            //builder.RegisterType<ServiceRepository>()
            //   .As<IServiceRepository>()
            //   .InstancePerHttpRequest();

            IContainer container = builder.Build();
            DependencyResolver.SetResolver(new AutofacDependencyResolver(container));
        }
    }
}