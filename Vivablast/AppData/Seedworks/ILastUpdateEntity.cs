using System;

namespace ApData.Seedworks
{
    public interface ILastUpdateEntity
    {
        DateTime? LastUpdate { get; set; }
    }
}
