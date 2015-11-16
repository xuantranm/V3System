using System.Collections.Generic;
using System.Linq;
using ApBusiness.Domains;
using ApService.Seedworks;


namespace ApService.Services
{
    public class SystemService : ISystemService
    {
        private readonly IUnitOfWork _unitOfWork;

        private readonly IConfiguration _configuration;

        private readonly ILogger _logger;

        private readonly IRepository<PageContent> _pageContentRepository;
        private readonly IRepository<LookUp> _lookupRepository;
        private readonly IRepository<Document> _documentRepository;
        private readonly IRepository<SystemDownMessages> _systemMessageRepository;
        private readonly IRepository<Transaction> _transactionRepository;
        private readonly IApplicationRepository _customApplicationRepository;

        public SystemService(
            IUnitOfWork unitOfWork,
            IConfiguration configuration,
            ILogger logger,
            IRepository<PageContent> pageContentRepository,
            IRepository<LookUp> lookupRepository,
            IRepository<Document> documentRepository,
            IRepository<SystemDownMessages> systemMessageRepository,
            IRepository<Transaction> transactionRepository,
            IApplicationRepository customApplicationRepository)
        {
            _unitOfWork = unitOfWork;
            _configuration = configuration;
            _logger = logger;

            _pageContentRepository = pageContentRepository;
            _lookupRepository = lookupRepository;
            _documentRepository = documentRepository;
            _systemMessageRepository = systemMessageRepository;
            _transactionRepository = transactionRepository;
            _customApplicationRepository = customApplicationRepository;
        }

        public IList<PageContent> GetText()
        {
            return _pageContentRepository.GetAll().ToList();
        }

        public string GetTemporaryPassword(int passwordLength)
        {
            return Utility.Random(passwordLength);
        }

        public IList<LookUp> GetLookupByType(string type, LookUp lookUpSelect = null)
        {
            var lookup = _lookupRepository.Find(m => m.LookUpType == type && m.Active_YN == "Y").OrderBy(m => m.LookUpValue).ToList();
            if (lookUpSelect != null) lookup.Insert(0, lookUpSelect);
            return lookup;
        }

        public LookUp GetLookupByType(string type, string lookUpKey)
        {
            var lookup = _lookupRepository.Find(m => m.LookUpType == type && m.LookUpKey == lookUpKey && m.Active_YN == "Y").FirstOrDefault();
            
            return lookup;
        }

        public string GetRegion(string type, string country)
        {
            var region = string.Empty;
            if (!string.IsNullOrEmpty(country))
            {
                region = _lookupRepository.FindOne(m => m.LookUpType == type && m.Active_YN == "Y" && m.LookUpValue == country).Region;
            }
            return region;
        }

        public string GetRegionByLookupId(string type, int ? country)
        {
            var region = string.Empty;
            if (country != null)
            {
                var lookup = _lookupRepository.FindOne(m => m.LookUpType == type && m.Active_YN == "Y" && m.LookUpID == country);
                if (lookup != null)
                    region = lookup.Region;
            }
            return region;
        }

        public LookUp GetLookupById(int lookUpId)
        {
            return _lookupRepository.GetByKey(lookUpId);
        }

        public LookUp GetLookup(string lookupType, string lookupKey)
        {
            return _lookupRepository.FindOne(i => i.LookUpType == lookupType && i.LookUpKey == lookupKey);
        }

        public SystemDownMessages GetDownMessages(EDownTimeMessageType downType)
        {
            return _systemMessageRepository.FindOne(x => x.MessageType == (int)downType);
        }

        public int InsertTransaction(int applicationId, int paymentType)
        {
            return _customApplicationRepository.InsertTransaction(applicationId, paymentType);
        }

        public void UpdateTransaction(PaymentResponse response, string extra)
        {
            _customApplicationRepository.UpdateTransaction(response, extra);
        }

        public Transaction GetTransaction(int transactionId)
        {
            return _transactionRepository.FindOne(i => i.TransactionId == transactionId);
        }
    }
}
