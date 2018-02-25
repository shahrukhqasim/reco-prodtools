## External vars
curDir=${1}
outDir=${2}
cfgFile1=${3}
cfgFile2=${4}
cfgFile3=${5}
localFlag=${6}
CMSSWVER=${7} # CMSSW_8_1_0_pre7
CMSSWDIR=${8} # ${curDir}/../${CMSSWVER}
CMSSWARCH=${9} # slc6_amd64_gcc530
eosArea=${10}
dataTier=${11}

##Create Work Area
export SCRAM_ARCH=${CMSSWARCH}
source /afs/cern.ch/cms/cmsset_default.sh
eval `scramv1 project CMSSW ${CMSSWVER}`
cd ${CMSSWVER}/
rm -rf ./*
cp -r -d ${CMSSWDIR}/* ./
cd src
eval `scramv1 runtime -sh`
edmPluginRefresh -p ../lib/$SCRAM_ARCH

## Execute job and retrieve the outputs
echo "Job running on `hostname` at `date`"

cmsRun ${curDir}/${outDir}/cfg/${cfgFile1}

# copy to outDir in curDir or at given EOS area
if [ ${localFlag} == "True" ]
  then
    cp *GSD*.root ${curDir}/${outDir}/GSD/
  else
    xrdcp -N -v *GSD*.root root://eoscms.cern.ch/${eosArea}/${outDir}/GSD/
fi


cmsRun ${curDir}/${outDir}/cfg/${cfgFile2}

# copy to outDir in curDir or at given EOS area
if [ ${localFlag} == "True" ]
  then
    cp *RECO*.root ${curDir}/${outDir}/RECO/
  else
    xrdcp -N -v *RECO*.root root://eoscms.cern.ch/${eosArea}/${outDir}/RECO/
fi


cmsRun ${curDir}/${outDir}/cfg/${cfgFile3}

# copy to outDir in curDir or at given EOS area
if [ ${localFlag} == "True" ]
  then
    cp *NTUP*.root ${curDir}/${outDir}/NTUP/
  else
    xrdcp -N -v *NTUP*.root root://eoscms.cern.ch/${eosArea}/${outDir}/NTUP/
fi