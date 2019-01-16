select OPERNAME,
count (case when ERRORDESC='交易成功' then REQSYSCODE end ) as count_交易成功,
count (case when ERRORDESC='解约成功' then REQSYSCODE end ) as count_解约成功,
count (case when ERRORDESC='失败' then REQSYSCODE end) as count_失败
from bdw_fdl.FDL_T02_BINDCARD_JOURNAL
group by OPERNAME