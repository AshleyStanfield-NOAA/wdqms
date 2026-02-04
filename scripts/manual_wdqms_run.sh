
#**** Script set up to run WDQMS


#-- Setup --
export Pdate=$(date +'%Y%m%d' -d "1 day ago") 
export Pdate=20241106
echo Pdate = $Pdate
export Dout=/lfs/h2/emc/ptmp/noscrub/ashley.stanfield/CRON/storage/wdqms/temp_data
export SDPath=/lfs/h2/emc/obsproc/noscrub/ashley.stanfield/wdqms_new/wdqms/src/wdqms/wdqms_driver.py
export OutPath=/lfs/h2/emc/obsproc/noscrub/ashley.stanfield/Data.KEEP/CRON/wdqms/data_new
export DiagOutPath=/lfs/h2/emc/ptmp/ashley.stanfield/CRON/wdqms/diagfiles/

#RZDM Variables
#export WEBDIR=/home/people/emc/ftp/jcsda/WDQMS/NCEP
export WEBDIR=/home/people/emc/ftp/wdqms/ncep
export WSUSER=rstanfield
export WS=emcrzdm.ncep.noaa.gov

export flag_00=1
export flag_06=1
export flag_12=1
export flag_18=1
export flag_s=1
export flag_t=1
export flag_m=1

mkdir -p ${Dout} ${OutPath} ${DiagOutPath}

module load python/3.8.6

#-- 00z --
if [ ${flag_00} == 1 ]; then
  cp /lfs/h1/ops/prod/com/gfs/v16.3/gdas.${Pdate}/00/atmos/gdas.t00z.cnvstat ${Dout}/
  tar -xvf ${Dout}/gdas.t00z.cnvstat -C ${Dout}/
  export File1=${Dout}/diag_conv_t_ges.${Pdate}00.nc4
  export File2=${Dout}/diag_conv_q_ges.${Pdate}00.nc4
  export File3=${Dout}/diag_conv_ps_ges.${Pdate}00.nc4
  export File4=${Dout}/diag_conv_uv_ges.${Pdate}00.nc4
  gunzip -f ${File1}.gz
  gunzip -f ${File2}.gz
  gunzip -f ${File3}.gz
  gunzip -f ${File4}.gz
  cp ${File1} ${DiagOutPath}/diag_conv_t_ges.${Pdate}00.nc4
  cp ${File2} ${DiagOutPath}/diag_conv_q_ges.${Pdate}00.nc4
  cp ${File3} ${DiagOutPath}/diag_conv_ps_ges.${Pdate}00.nc4
  cp ${File4} ${DiagOutPath}/diag_conv_uv_ges.${Pdate}00.nc4

# Execute and Transfer  
  #echo python /lfs/h2/emc/obsproc/noscrub/ashley.stanfield/storage/alt_wdqms/scripts/wdqms/src/wdqms/wdqms.py -i ${File1} ${File2} ${File3} ${File4} -t SYNOP -o /lfs/h2/emc/obsproc/noscrub/ashley.stanfield/storage/alt_wdqms/wdqms_output/ -v
  if [ ${flag_s} == 1 ]; then 
    python ${SDPath} -i ${File1} ${File2} ${File3} ${File4} -t SYNOP -o ${OutPath} -v
    scp ${OutPath}/NCEP_SYNOP_${Pdate}_00.csv  $WSUSER@$WS:${WEBDIR}/synop/00/NCEP_SYNOP_${Pdate}_00.csv
    ssh -l $WSUSER $WS " chmod 755 ${WEBDIR}/synop/00/*"
  fi
  if [ ${flag_t} == 1 ]; then
    python ${SDPath} -i ${File1} ${File2} ${File3} ${File4} -t TEMP -o ${OutPath} -v
    scp ${OutPath}/NCEP_TEMP_${Pdate}_00.csv  $WSUSER@$WS:${WEBDIR}/temp/00/NCEP_TEMP_${Pdate}_00.csv
    ssh -l $WSUSER $WS " chmod 755 ${WEBDIR}/temp/00/*"
  fi
  if [ ${flag_m} == 1 ]; then 
    python ${SDPath} -i ${File1} ${File2} ${File3} ${File4} -t MARINE -o ${OutPath} -v
    scp ${OutPath}/NCEP_MARINE_${Pdate}_00.csv  $WSUSER@$WS:${WEBDIR}/marine/00/NCEP_MARINE_${Pdate}_00.csv
    ssh -l $WSUSER $WS " chmod 755 ${WEBDIR}/marine/00/*"
  fi
  else echo "Skipping 00z..."
fi #end flag_00

#-- 06z --
if [ ${flag_06} == 1 ]; then
  cp /lfs/h1/ops/prod/com/gfs/v16.3/gdas.${Pdate}/06/atmos/gdas.t06z.cnvstat ${Dout}/
  tar -xvf ${Dout}/gdas.t06z.cnvstat -C ${Dout}/
  export File1=${Dout}/diag_conv_t_ges.${Pdate}06.nc4
  export File2=${Dout}/diag_conv_q_ges.${Pdate}06.nc4
  export File3=${Dout}/diag_conv_ps_ges.${Pdate}06.nc4
  export File4=${Dout}/diag_conv_uv_ges.${Pdate}06.nc4
  gunzip -f ${File1}.gz
  gunzip -f ${File2}.gz
  gunzip -f ${File3}.gz
  gunzip -f ${File4}.gz
  cp ${File1} ${DiagOutPath}/diag_conv_t_ges.${Pdate}06.nc4
  cp ${File2} ${DiagOutPath}/diag_conv_q_ges.${Pdate}06.nc4
  cp ${File3} ${DiagOutPath}/diag_conv_ps_ges.${Pdate}06.nc4
  cp ${File4} ${DiagOutPath}/diag_conv_uv_ges.${Pdate}06.nc4
  if [ ${flag_s} == 1 ]; then
	  python ${SDPath} -i ${File1} ${File2} ${File3} ${File4} -t SYNOP -o ${OutPath} -v
          scp ${OutPath}/NCEP_SYNOP_${Pdate}_06.csv  $WSUSER@$WS:${WEBDIR}/synop/06/NCEP_SYNOP_${Pdate}_06.csv 
          ssh -l $WSUSER $WS " chmod 755 ${WEBDIR}/synop/06/*"
  fi
  if [ ${flag_t} == 1 ]; then
	  python ${SDPath} -i ${File1} ${File2} ${File3} ${File4} -t TEMP -o ${OutPath} -v
          scp ${OutPath}/NCEP_TEMP_${Pdate}_06.csv  $WSUSER@$WS:${WEBDIR}/temp/06/NCEP_TEMP_${Pdate}_06.csv
          ssh -l $WSUSER $WS " chmod 755 ${WEBDIR}/temp/06/*"
  fi
  if [ ${flag_m} == 1 ]; then
	  python ${SDPath} -i ${File1} ${File2} ${File3} ${File4} -t MARINE -o ${OutPath} -v
          scp ${OutPath}/NCEP_MARINE_${Pdate}_06.csv  $WSUSER@$WS:${WEBDIR}/marine/06/NCEP_MARINE_${Pdate}_06.csv
          ssh -l $WSUSER $WS " chmod 755 ${WEBDIR}/marine/06/*"
  fi
  else echo "Skipping 06z..."
fi

#-- 12z --
if [ ${flag_12} == 1 ]; then
  echo "Beginning 12z..."
  cp /lfs/h1/ops/prod/com/gfs/v16.3/gdas.${Pdate}/12/atmos/gdas.t12z.cnvstat ${Dout}/
  tar -xvf ${Dout}/gdas.t12z.cnvstat -C ${Dout}/
  export File1=${Dout}/diag_conv_t_ges.${Pdate}12.nc4
  export File2=${Dout}/diag_conv_q_ges.${Pdate}12.nc4
  export File3=${Dout}/diag_conv_ps_ges.${Pdate}12.nc4
  export File4=${Dout}/diag_conv_uv_ges.${Pdate}12.nc4
  gunzip -f ${File1}.gz
  gunzip -f ${File2}.gz
  gunzip -f ${File3}.gz
  gunzip -f ${File4}.gz
  cp ${File1} ${DiagOutPath}/diag_conv_t_ges.${Pdate}12.nc4
  cp ${File2} ${DiagOutPath}/diag_conv_q_ges.${Pdate}12.nc4
  cp ${File3} ${DiagOutPath}/diag_conv_ps_ges.${Pdate}12.nc4
  cp ${File4} ${DiagOutPath}/diag_conv_uv_ges.${Pdate}12.nc4

  #Execute and Transfer to RZDM
  if [ ${flag_s} == 1 ]; then 
      python ${SDPath} -i ${File1} ${File2} ${File3} ${File4} -t SYNOP -o ${OutPath} -v
      scp ${OutPath}/NCEP_SYNOP_${Pdate}_12.csv  $WSUSER@$WS:${WEBDIR}/synop/12/NCEP_SYNOP_${Pdate}_12.csv
      ssh -l $WSUSER $WS " chmod 755 ${WEBDIR}/synop/12/*"
  fi
  if [ ${flag_t} == 1 ]; then
      python ${SDPath} -i ${File1} ${File2} ${File3} ${File4} -t TEMP -o ${OutPath} -v
      scp ${OutPath}/NCEP_TEMP_${Pdate}_12.csv  $WSUSER@$WS:${WEBDIR}/temp/12/NCEP_TEMP_${Pdate}_12.csv
      ssh -l $WSUSER $WS " chmod 755 ${WEBDIR}/temp/12/*"
  fi
  if [ ${flag_m} == 1 ]; then 
      python ${SDPath} -i ${File1} ${File2} ${File3} ${File4} -t MARINE -o ${OutPath} -v
      scp ${OutPath}/NCEP_MARINE_${Pdate}_12.csv  $WSUSER@$WS:${WEBDIR}/marine/12/NCEP_MARINE_${Pdate}_12.csv
      ssh -l $WSUSER $WS " chmod 755 ${WEBDIR}/marine/12/*"
  fi
  else echo "Skipping 12z..."
fi  #end flag_12

#-- 18z --
if [ ${flag_18} == 1 ]; then
  cp /lfs/h1/ops/prod/com/gfs/v16.3/gdas.${Pdate}/18/atmos/gdas.t18z.cnvstat ${Dout}/
  tar -xvf ${Dout}/gdas.t18z.cnvstat -C ${Dout}/
  export File1=${Dout}/diag_conv_t_ges.${Pdate}18.nc4
  export File2=${Dout}/diag_conv_q_ges.${Pdate}18.nc4
  export File3=${Dout}/diag_conv_ps_ges.${Pdate}18.nc4
  export File4=${Dout}/diag_conv_uv_ges.${Pdate}18.nc4
  gunzip -f ${File1}.gz
  gunzip -f ${File2}.gz
  gunzip -f ${File3}.gz
  gunzip -f ${File4}.gz
  cp ${File1} ${DiagOutPath}/diag_conv_t_ges.${Pdate}18.nc4
  cp ${File2} ${DiagOutPath}/diag_conv_q_ges.${Pdate}18.nc4
  cp ${File3} ${DiagOutPath}/diag_conv_ps_ges.${Pdate}18.nc4
  cp ${File4} ${DiagOutPath}/diag_conv_uv_ges.${Pdate}18.nc4
  python ${SDPath} -i ${File1} ${File2} ${File3} ${File4} -t SYNOP -o ${OutPath} -v
  python ${SDPath} -i ${File1} ${File2} ${File3} ${File4} -t TEMP -o ${OutPath} -v
  python ${SDPath} -i ${File1} ${File2} ${File3} ${File4} -t MARINE -o ${OutPath} -v

  #Transfer to RZDM
  scp ${OutPath}/NCEP_SYNOP_${Pdate}_18.csv  $WSUSER@$WS:${WEBDIR}/synop/18/NCEP_SYNOP_${Pdate}_18.csv
  scp ${OutPath}/NCEP_TEMP_${Pdate}_18.csv  $WSUSER@$WS:${WEBDIR}/temp/18/NCEP_TEMP_${Pdate}_18.csv
  scp ${OutPath}/NCEP_MARINE_${Pdate}_18.csv  $WSUSER@$WS:${WEBDIR}/marine/18/NCEP_MARINE_${Pdate}_18.csv
  ssh -l $WSUSER $WS " chmod 755 ${WEBDIR}/synop/18/*"
  ssh -l $WSUSER $WS " chmod 755 ${WEBDIR}/temp/18/*"
  ssh -l $WSUSER $WS " chmod 755 ${WEBDIR}/marine/18/*"
  else echo "Skipping 18z..."
fi

#python create_wdqms.py -i /scratch1/NCEPDEV/da/Kevin.Dougherty/wdqms/files/diag_files/diag_conv_t_ges.2022070700.nc4 /scratch1/NCEPDEV/da/Kevin.Dougherty/wdqms/files/diag_files/diag_conv_q_ges.2022070700.nc4 /scratch1/NCEPDEV/da/Kevin.Dougherty/wdqms/files/diag_files/diag_conv_ps_ges.2022070700.nc4 /scratch1/NCEPDEV/da/Kevin.Dougherty/wdqms/files/diag_files/diag_conv_uv_ges.2022070700.nc4 -t SYNOP -o ./ -v
