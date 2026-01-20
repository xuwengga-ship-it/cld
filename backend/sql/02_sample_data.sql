-- Sample data for Graph Ontology Explorer
-- Execute this script manually to populate sample data

-- Insert Ontology Types
INSERT INTO ontology_type (name, description, icon, color) VALUES
('公司', '企业法人实体', 'building', '#1890FF'),
('供应商', '供应商实体', 'shop', '#52C41A'),
('经销商', '经销商实体', 'shop', '#FA8C16'),
('产品', '产品实体', 'inbox', '#722ED1'),
('人员', '人员实体', 'user', '#EB2F96');

-- Insert Entity Instances
-- Companies
INSERT INTO entity_instance (name, description, ontology_type_id, properties) VALUES
('海王集团股份有限公司', '海王集团总部', 1, '{"注册资本":"263112.3257万人民币","成立日期":"1992-12-13","法定代表人":"张锋","统一社会信用代码":"914403001924440861","人员规模":"100-499人"}'),
('宁波海龙科技有限公司', '宁波分公司', 1, '{"成立日期":"2015-03-20","员工数":"150人"}'),
('南京科技有限公司', '南京子公司', 1, '{"成立日期":"2016-08-15","员工数":"200人"}'),
('海王星辰股份有限公司', '零售子公司', 1, '{"成立日期":"2010-05-10","员工数":"300人"}'),
('中国医药集团', '中国医药集团公司', 1, '{"成立日期":"2000-01-01","员工数":"1000人"}'),
('阿里巴巴集团', '阿里巴巴集团', 1, '{"成立日期":"1999-09-09","员工数":"10000人"}');

-- Suppliers
INSERT INTO entity_instance (name, description, ontology_type_id, properties) VALUES
('供应商A', '原材料供应商A', 2, '{"供应类型":"原材料","合作年限":"5年"}'),
('供应商B', '原材料供应商B', 2, '{"供应类型":"原材料","合作年限":"3年"}'),
('供应商C', '设备供应商C', 2, '{"供应类型":"设备","合作年限":"7年"}'),
('供应商D', '服务供应商D', 2, '{"供应类型":"服务","合作年限":"2年"}'),
('商贸股份公司', '商贸公司', 2, '{"供应类型":"综合","合作年限":"10年"}');

-- Distributors
INSERT INTO entity_instance (name, description, ontology_type_id, properties) VALUES
('经销商A', '华东地区经销商', 3, '{"区域":"华东","销售额":"1000万"}'),
('经销商B', '华南地区经销商', 3, '{"区域":"华南","销售额":"800万"}'),
('经销商C', '华北地区经销商', 3, '{"区域":"华北","销售额":"1200万"}');

-- Insert Relation Types
INSERT INTO relation_type (name, description, source_type_id, target_type_id, color) VALUES
('拥有', '公司拥有子公司', 1, 1, '#1890FF'),
('供应', '供应商供应给公司', 2, 1, '#52C41A'),
('销售', '公司销售给经销商', 1, 3, '#FA8C16'),
('合作', '公司间合作关系', 1, 1, '#722ED1'),
('关联', '实体间关联关系', 1, 2, '#13C2C2');

-- Insert Relationships with time series data
-- Current relationships (valid_to is NULL)
INSERT INTO relationship (source_entity_id, target_entity_id, relation_type_id, properties, valid_from, valid_to) VALUES
(1, 2, 1, '{"持股比例":"100%","投资金额":"5000万"}', '2015-03-20', NULL),
(1, 3, 1, '{"持股比例":"100%","投资金额":"8000万"}', '2016-08-15', NULL),
(1, 4, 1, '{"持股比例":"80%","投资金额":"10000万"}', '2010-05-10', NULL),
(7, 1, 2, '{"供应产品":"原材料A","年供应额":"2000万"}', '2018-01-01', NULL),
(8, 1, 2, '{"供应产品":"原材料B","年供应额":"1500万"}', '2019-06-01', NULL),
(9, 2, 2, '{"供应产品":"设备","年供应额":"3000万"}', '2017-03-01', NULL),
(10, 2, 2, '{"供应产品":"服务","年供应额":"500万"}', '2020-01-01', NULL),
(1, 12, 3, '{"年销售额":"1000万","产品":"产品A"}', '2019-01-01', NULL),
(2, 12, 3, '{"年销售额":"800万","产品":"产品B"}', '2020-01-01', NULL),
(2, 13, 3, '{"年销售额":"1200万","产品":"产品C"}', '2018-06-01', NULL),
(1, 5, 4, '{"合作项目":"医药研发","合作期限":"5年"}', '2020-01-01', NULL),
(4, 5, 4, '{"合作项目":"零售渠道","合作期限":"3年"}', '2021-01-01', NULL);

-- Historical relationships (valid_to is set)
INSERT INTO relationship (source_entity_id, target_entity_id, relation_type_id, properties, valid_from, valid_to) VALUES
(11, 1, 2, '{"供应产品":"原材料","年供应额":"1000万"}', '2015-01-01', '2020-12-31'),
(1, 14, 3, '{"年销售额":"500万","产品":"产品D"}', '2015-01-01', '2019-12-31'),
(1, 6, 4, '{"合作项目":"电商平台","合作期限":"2年"}', '2018-01-01', '2020-12-31');

-- Future relationships
INSERT INTO relationship (source_entity_id, target_entity_id, relation_type_id, properties, valid_from, valid_to) VALUES
(3, 4, 4, '{"合作项目":"新产品开发","合作期限":"3年"}', '2027-01-01', '2030-12-31');

-- Insert Ontology Actions
INSERT INTO ontology_action (name, description, ontology_type_id, icon, action_type, config) VALUES
('查看详情', '查看公司详细信息', 1, 'info-circle', 'view', '{"url":"/company/detail"}'),
('编辑信息', '编辑公司信息', 1, 'edit', 'edit', '{"url":"/company/edit"}'),
('查看报表', '查看公司报表', 1, 'bar-chart', 'report', '{"url":"/company/report"}'),
('添加子公司', '添加新的子公司', 1, 'plus', 'add', '{"url":"/company/add-subsidiary"}'),
('查看供应商详情', '查看供应商详细信息', 2, 'info-circle', 'view', '{"url":"/supplier/detail"}'),
('评估供应商', '评估供应商绩效', 2, 'audit', 'evaluate', '{"url":"/supplier/evaluate"}'),
('查看经销商详情', '查看经销商详细信息', 3, 'info-circle', 'view', '{"url":"/distributor/detail"}'),
('销售分析', '分析经销商销售数据', 3, 'line-chart', 'analyze', '{"url":"/distributor/analyze"}');
