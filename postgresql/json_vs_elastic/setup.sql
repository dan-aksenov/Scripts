create table test_json as
select ind.id_indication, svc.id_service, hou.id_house, pr.id_profile, pay.id_payment,
       json_build_object('id_indication', ind.id_indication,
			 'id_counter_ext', ind.id_counter_ext,
			 'id_service', ind.id_service,
			 'dt_indication', to_char(ind.dt_indication, 'yyyy-MM-dd HH24:mi:ss'),
			 'id_zone', ind.id_counter_zone,
			 'vl_indication', ind.vl_indication,
			 'nn_ls', svc.nn_ls)::jsonb || ind.vl_indication_param || svc.vl_provider ||
       json_build_object('nm_house', hou.nm_house,
			 'nm_address', hou.nm_address,
			 'dt_house', to_char(hou.dt_create, 'yyyy-MM-dd HH24:mi:ss'),
			 'id_profile', pr.id_profile,
			 'nm_email', pr.nm_email,
			 'nm_first', pr.nm_first,
			 'nm_middle', pr.nm_middle,
			 'nm_last', pr.nm_last,
			 'dt_auth', to_char(pr.dt_last_auth, 'yyyy-MM-dd HH24:mi:ss'),
			 'dt_reg', to_char(pr.dt_reg, 'yyyy-MM-dd HH24:mi:ss'),
			 'nm_psw', pr.nm_psw,
			 'nn_phone', pr.nn_phone,
			 'kd_src', pr.kd_source,
			 'dt_pay', to_char(pay.dt_create, 'yyyy-MM-dd HH24:mi:ss'),
			 'vl_pay', pay.vl_payment,
			 'dt_pay_period', to_char(pay.dt_period, 'yyyy-MM-dd HH24:mi:ss'),
			 'id_shop_pay', pay.id_shop_pps,
			 'id_transfer_pay', pay.id_transfer_pps)::jsonb as vl_data
  from lka_profile pr 
  left join lka_house hou on pr.id_profile = hou.id_house
  left join lka_service svc on hou.id_house = svc.id_house
  left join lka_indication ind on svc.id_service = ind.id_service
  left join lka_payment pay on pay.id_profile = pr.id_profile;

ALTER TABLE test_json add COLUMN id SERIAL PRIMARY KEY;
 

--json
CREATE INDEX idx_json ON test_json((vl_data->'id_tu'));
--gin
CREATE INDEX idx_gin ON test_json USING GIN (vl_data jsonb_path_ops);
--elastic
CREATE INDEX idx_elastic
  ON public.test_json
  USING zombodb
  (zdb('test_json'::regclass, ctid), zdb(test_json.*))
WITH (url='http://localhost:9200/');;
