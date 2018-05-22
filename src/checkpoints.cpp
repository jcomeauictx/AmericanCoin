// Copyright (c) 2009-2012 The Bitcoin developers
// Copyright (c) 2011-2012 Litecoin Developers
// Copyright (c) 2013 Americancoin Developers

// Distributed under the MIT/X11 software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include <boost/assign/list_of.hpp> // for 'map_list_of()'
#include <boost/foreach.hpp>

#include "checkpoints.h"

#include "main.h"
#include "uint256.h"

namespace Checkpoints
{
    typedef std::map<int, uint256> MapCheckpoints;

    //
    // What makes a good checkpoint block?
    // + Is surrounded by blocks with reasonable timestamps
    //   (no blocks before with a timestamp after, none after with
    //    timestamp before)
    // + Contains no strange transactions
    //
    static MapCheckpoints mapCheckpoints =
            boost::assign::map_list_of
            (     0, uint256("0xe235425c8314df2f26b94d89fd5582edc74d80cf39d105107ea6cd12d8898491"))
            (     9000, uint256("0x6aaddca66be07c4df9c5bb14ec5a46edfa13b0e208187b1275744e4354339a8b"))			
            (     12150, uint256("0x91f24da86e5aaf6cfcf146e62d6b6cdc63e1b1ce699f776399e311d707cc1aa6"))		
            (     13550, uint256("0x0c50d43e4982187e704c8c9d2b33d2617aed69ee471dffb744e58414c961cb11"))	
            (     15121, uint256("0x040e045718181b2467df5c2eb2cd3a95ee45240b54cbffc68ef00aa254a961a8"))
            (     50000, uint256("0xd05ffe2d08469eaf8e84f50de97bda320ffa5467ce768e3b12e550dfc850c499"))
	    (     100000, uint256("0x804519b95b4f036a85e2f2a5c8bd53a04794a88df7e2df97e0359a71426bb075"))
	    (     150000, uint256("0x7396ad19096bc56de1035d5bda81252af17a864a821643e8913eddf8c9ad9338"))
	    (     200000, uint256("0x3d9ac91d5c4f753d7f70e7081fc857c0ddb0c510a0aef7d144ec63db3886a4bb"))
	    (     250000, uint256("0xd8e87de02ec9e305511742f2aaf05e655b1d202966ba08175e20ff5be5af8132"))
	    (     300000, uint256("0x69e652e43906a8f967f9aec1db38be3c8863a9323552ebba3f1f5c5fbb197e75"))			

            ;


    bool CheckBlock(int nHeight, const uint256& hash)
    {
        if (fTestNet) return true; // Testnet has no checkpoints

        MapCheckpoints::const_iterator i = mapCheckpoints.find(nHeight);
        if (i == mapCheckpoints.end()) return true;
        return hash == i->second;
    }

    int GetTotalBlocksEstimate()
    {
        if (fTestNet) return 0;
		
		//return 0;
        return mapCheckpoints.rbegin()->first;
    }

    CBlockIndex* GetLastCheckpoint(const std::map<uint256, CBlockIndex*>& mapBlockIndex)
    {
        if (fTestNet) return NULL;

        BOOST_REVERSE_FOREACH(const MapCheckpoints::value_type& i, mapCheckpoints)
        {
            const uint256& hash = i.second;
            std::map<uint256, CBlockIndex*>::const_iterator t = mapBlockIndex.find(hash);
            if (t != mapBlockIndex.end())
                return t->second;
        }
        return NULL;
    }
}
