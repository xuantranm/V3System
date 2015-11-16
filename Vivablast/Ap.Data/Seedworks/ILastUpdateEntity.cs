using System;

namespace Ap.Data.Seedworks
{
    public interface ILastUpdateEntity
    {
        DateTime? LastUpdate { get; set; }
    }
}
