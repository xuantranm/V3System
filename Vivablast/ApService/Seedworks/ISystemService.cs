using System.Collections.Generic;
using ApBusiness.Domains;

namespace ApService.Seedworks
{
    public interface ISystemService
    {
        IList<LookUp> GetLookupByType(string type, LookUp lookUpSelect = null);

        LookUp GetLookupByType(string type, string lookUpKey);

        LookUp GetLookupById(int lookUpId);

        LookUp GetLookup(string lookupType, string lookupKey);
    }
}
