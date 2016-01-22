--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.10
-- Dumped by pg_dump version 9.3.10
-- Started on 2016-01-22 16:58:22 BRT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 200 (class 1259 OID 21961)
-- Name: custom_fields; Type: TABLE; Schema: public; Owner: j; Tablespace:
--

CREATE TABLE custom_fields (
    id integer NOT NULL,
    name character varying,
    format character varying DEFAULT ''::character varying,
    default_value text DEFAULT ''::text,
    customized_type character varying,
    extras text DEFAULT ''::text,
    active boolean DEFAULT false,
    required boolean DEFAULT false,
    signup boolean DEFAULT false,
    environment_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.custom_fields OWNER TO j;

--
-- TOC entry 199 (class 1259 OID 21959)
-- Name: custom_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: j
--

CREATE SEQUENCE custom_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.custom_fields_id_seq OWNER TO j;

--
-- TOC entry 2308 (class 0 OID 0)
-- Dependencies: 199
-- Name: custom_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: j
--

ALTER SEQUENCE custom_fields_id_seq OWNED BY custom_fields.id;


--
-- TOC entry 2185 (class 2604 OID 21964)
-- Name: id; Type: DEFAULT; Schema: public; Owner: j
--

ALTER TABLE ONLY custom_fields ALTER COLUMN id SET DEFAULT nextval('custom_fields_id_seq'::regclass);


--
-- TOC entry 2303 (class 0 OID 21961)
-- Dependencies: 200
-- Data for Name: custom_fields; Type: TABLE DATA; Schema: public; Owner: j
--

INSERT INTO custom_fields VALUES (4, 'UF', 'list', '', '--- Community
...
',  '---
- AC
- AL
- AP
- AM
- BA
- CE
- DF
- ES
- GO
- MA
- MT
- MS
- MG
- PR
- PB
- PA
- PE
- PI
- RJ
- RN
- RS
- RO
- RR
- SC
- SE
- SP
- TO
', true, true, true, 1, '2016-01-22 19:11:15.396396', '2016-01-22 19:11:15.396396');

INSERT INTO custom_fields VALUES (5, 'Tipo Telecentro', 'list', 'Comunitário', '--- Community
...
', '---
- Comunitário
- Escola Aberta
- Espaço Cidadão
- Ponto Cultural
', true, true, true, 1, '2016-01-22 19:11:15.430324', '2016-01-22 19:11:15.430324');
INSERT INTO custom_fields VALUES (6, 'Instituição Beneficiada', 'string', '', '--- Community
...
', '', true, true, true, 1, '2016-01-22 19:11:15.444565', '2016-01-22 19:11:15.444565');
INSERT INTO custom_fields VALUES (7, 'Instituição Parceira', 'string', '', '--- Community
...
', '', true, false, true, 1, '2016-01-22 19:11:15.452095', '2016-01-22 19:11:15.452095');
INSERT INTO custom_fields VALUES (9, 'Data da Adesão', 'date', '', '--- Community
...
', '', true, false, true, 1, '2016-01-22 19:11:15.478095', '2016-01-22 19:11:15.478095');
INSERT INTO custom_fields VALUES (10, 'PCs Recebidos', 'numeric', '0', '--- Community
...
', '', true, false, false, 1, '2016-01-22 19:11:15.493807', '2016-01-22 19:11:15.493807');
INSERT INTO custom_fields VALUES (11, 'PCs Solicitados', 'numeric', '0', '--- Community
...
', '', true, false, false, 1, '2016-01-22 19:11:15.502091', '2016-01-22 19:11:15.502091');
INSERT INTO custom_fields VALUES (12, 'PCs doados', 'numeric', '0', '--- Community
...
', '', true, false, false, 1, '2016-01-22 19:21:59.701271', '2016-01-22 19:21:59.701271');
INSERT INTO custom_fields VALUES (13, 'PCs solicitados para serem doados', 'numeric', '0', '--- Community
...
', '', true, false, false, 1, '2016-01-22 19:21:59.719135', '2016-01-22 19:21:59.719135');
INSERT INTO custom_fields VALUES (14, 'Hora inalguração', 'string', '', '--- Community
...
', '', true, false, false, 1, '2016-01-22 19:21:59.729836', '2016-01-22 19:21:59.729836');
INSERT INTO custom_fields VALUES (15, 'Status', 'list', 'Sem Informação', '--- Community
...
', '---
- Ativo
- Inativo
- Parcial
- Sem Informação
', true, false, true, 1, '2016-01-22 19:21:59.746512', '2016-01-22 19:21:59.746512');
INSERT INTO custom_fields VALUES (3, 'ID Telecentro', 'string', '', '--- Community
...
', '', true, false, true, 1, '2016-01-22 19:11:15.344879', '2016-01-22 19:30:40.726042');
INSERT INTO custom_fields VALUES (16, 'Município', 'string', '', '--- Community
...
', '', true, false, true, 1, '2016-01-22 19:30:40.813741', '2016-01-22 19:30:40.813741');
INSERT INTO custom_fields VALUES (20, 'Nome do responsável na instituição parceira  (Nome completo)', 'string', '', '--- Community
...
', '', true, false, true, 1, '2016-01-22 19:30:40.865717', '2016-01-22 19:30:40.865717');
INSERT INTO custom_fields VALUES (21, 'Telefone do responsável na instituição parceira', 'string', '', '--- Community
...
', '', true, false, true, 1, '2016-01-22 19:30:40.872691', '2016-01-22 19:30:40.872691');
INSERT INTO custom_fields VALUES (22, 'E-mail do responsável na instituição parceira', 'string', '', '--- Community
...
', '', true, false, true, 1, '2016-01-22 19:30:40.882506', '2016-01-22 19:30:40.882506');
INSERT INTO custom_fields VALUES (23, 'Nome do Responsável no Telecentro', 'string', '', '--- Community
...
', '', true, false, true, 1, '2016-01-22 19:30:40.898386', '2016-01-22 19:30:40.898386');
INSERT INTO custom_fields VALUES (24, 'CPF do Responsável no Telecentro', 'string', '', '--- Community
...
', '', true, false, true, 1, '2016-01-22 19:30:40.914459', '2016-01-22 19:30:40.914459');
INSERT INTO custom_fields VALUES (25, 'Telefone do Responsável no Telecentro', 'string', '', '--- Community
...
', '', true, false, true, 1, '2016-01-22 19:30:40.92304', '2016-01-22 19:30:40.92304');
INSERT INTO custom_fields VALUES (26, 'E-mail do Responsável no Telecentro', 'string', '', '--- Community
...
', '', true, false, true, 1, '2016-01-22 19:30:40.930855', '2016-01-22 19:30:40.930855');
INSERT INTO custom_fields VALUES (27, 'Nome do Responsável no Telecentro (2)', 'string', '', '--- Community
...
', '', true, false, false, 1, '2016-01-22 19:30:40.942179', '2016-01-22 19:30:40.942179');
INSERT INTO custom_fields VALUES (28, 'CPF do Responsável no Telecentro (2)', 'string', '', '--- Community
...
', '', false, false, false, 1, '2016-01-22 19:30:40.955388', '2016-01-22 19:30:40.955388');
INSERT INTO custom_fields VALUES (29, 'Telefone do Responsável no Telecentro (2)', 'string', '', '--- Community
...
', '', false, false, false, 1, '2016-01-22 19:30:40.963986', '2016-01-22 19:30:40.963986');
INSERT INTO custom_fields VALUES (30, 'E-mail do Responsável no Telecentro (2)', 'string', '', '--- Community
...
', '', false, false, false, 1, '2016-01-22 19:30:40.981349', '2016-01-22 19:30:40.981349');
INSERT INTO custom_fields VALUES (32, 'Localizado em Área Rural?', 'list', 'Não', '--- Community
...
', '---
- Sim
- Não
', true, false, true, 1, '2016-01-22 19:30:40.997982', '2016-01-22 19:30:40.997982');


--
-- TOC entry 2309 (class 0 OID 0)
-- Dependencies: 199
-- Name: custom_fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: j
--

SELECT pg_catalog.setval('custom_fields_id_seq', 33, true);


--
-- TOC entry 2193 (class 2606 OID 21975)
-- Name: custom_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: j; Tablespace:
--

ALTER TABLE ONLY custom_fields
    ADD CONSTRAINT custom_fields_pkey PRIMARY KEY (id);


--
-- TOC entry 2194 (class 1259 OID 21976)
-- Name: index_custom_field; Type: INDEX; Schema: public; Owner: j; Tablespace:
--

CREATE UNIQUE INDEX index_custom_field ON custom_fields USING btree (customized_type, name, environment_id);


-- Completed on 2016-01-22 16:58:22 BRT

--
-- PostgreSQL database dump complete
--
