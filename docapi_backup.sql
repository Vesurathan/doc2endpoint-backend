--
-- PostgreSQL database dump
--

\restrict yQ9PNXYmA2r8GD4MBJmunmVjVHX5tlEyKIKmjWpTdrP3k425l2oS22nOD9Bnibq

-- Dumped from database version 18.3 (Homebrew)
-- Dumped by pg_dump version 18.3 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: datasetstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.datasetstatus AS ENUM (
    'uploading',
    'extracting',
    'reviewing',
    'active',
    'failed'
);


ALTER TYPE public.datasetstatus OWNER TO postgres;

--
-- Name: doctype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.doctype AS ENUM (
    'excel',
    'csv',
    'pdf',
    'docx',
    'image'
);


ALTER TYPE public.doctype OWNER TO postgres;

--
-- Name: plan; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.plan AS ENUM (
    'free',
    'premium',
    'pro'
);


ALTER TYPE public.plan OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_keys (
    id integer NOT NULL,
    user_id integer NOT NULL,
    dataset_id integer,
    name character varying(255) NOT NULL,
    key_prefix character varying(20) NOT NULL,
    key_hash character varying(255) NOT NULL,
    is_active boolean NOT NULL,
    last_used_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    row_filters jsonb
);


ALTER TABLE public.api_keys OWNER TO postgres;

--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.api_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.api_keys_id_seq OWNER TO postgres;

--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;


--
-- Name: api_usage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_usage (
    id integer NOT NULL,
    api_key_id integer NOT NULL,
    dataset_id integer NOT NULL,
    method character varying(10) NOT NULL,
    path character varying(500) NOT NULL,
    status_code integer NOT NULL,
    response_time_ms integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    ip_address character varying(60),
    query_string character varying(1000)
);


ALTER TABLE public.api_usage OWNER TO postgres;

--
-- Name: api_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.api_usage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.api_usage_id_seq OWNER TO postgres;

--
-- Name: api_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.api_usage_id_seq OWNED BY public.api_usage.id;


--
-- Name: conversation_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversation_messages (
    id integer NOT NULL,
    dataset_id integer NOT NULL,
    role character varying(20) NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.conversation_messages OWNER TO postgres;

--
-- Name: conversation_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.conversation_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.conversation_messages_id_seq OWNER TO postgres;

--
-- Name: conversation_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.conversation_messages_id_seq OWNED BY public.conversation_messages.id;


--
-- Name: datasets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.datasets (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(255) NOT NULL,
    doc_type public.doctype NOT NULL,
    original_filename character varying(500) NOT NULL,
    file_path character varying(1000) NOT NULL,
    status public.datasetstatus NOT NULL,
    extracted_schema json,
    confirmed_schema json,
    table_name character varying(255),
    row_count integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    is_public boolean DEFAULT false,
    public_description text,
    webhook_url character varying(1000),
    webhook_secret character varying(100),
    sync_url character varying(2000),
    sync_interval_hours integer,
    last_synced_at timestamp with time zone,
    custom_endpoint character varying(255)
);


ALTER TABLE public.datasets OWNER TO postgres;

--
-- Name: datasets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.datasets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.datasets_id_seq OWNER TO postgres;

--
-- Name: datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.datasets_id_seq OWNED BY public.datasets.id;


--
-- Name: ds_1_employees_seed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ds_1_employees_seed (
    id integer NOT NULL,
    employee_id text,
    full_name text,
    department text,
    role text,
    hire_date text,
    location text
);


ALTER TABLE public.ds_1_employees_seed OWNER TO postgres;

--
-- Name: ds_1_employees_seed_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ds_1_employees_seed_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ds_1_employees_seed_id_seq OWNER TO postgres;

--
-- Name: ds_1_employees_seed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ds_1_employees_seed_id_seq OWNED BY public.ds_1_employees_seed.id;


--
-- Name: ds_1_invoices_seed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ds_1_invoices_seed (
    id integer NOT NULL,
    invoice_id text,
    customer_name text,
    amount double precision,
    status text,
    issue_date text,
    due_date text
);


ALTER TABLE public.ds_1_invoices_seed OWNER TO postgres;

--
-- Name: ds_1_invoices_seed_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ds_1_invoices_seed_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ds_1_invoices_seed_id_seq OWNER TO postgres;

--
-- Name: ds_1_invoices_seed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ds_1_invoices_seed_id_seq OWNED BY public.ds_1_invoices_seed.id;


--
-- Name: ds_1_sales_orders_a50a19dd; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ds_1_sales_orders_a50a19dd (
    id integer NOT NULL,
    order_id text,
    customer_name text,
    product text,
    category text,
    quantity bigint,
    unit_price double precision,
    total_amount double precision,
    order_date text,
    status text,
    region text
);


ALTER TABLE public.ds_1_sales_orders_a50a19dd OWNER TO postgres;

--
-- Name: ds_1_sales_orders_a50a19dd_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ds_1_sales_orders_a50a19dd_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ds_1_sales_orders_a50a19dd_id_seq OWNER TO postgres;

--
-- Name: ds_1_sales_orders_a50a19dd_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ds_1_sales_orders_a50a19dd_id_seq OWNED BY public.ds_1_sales_orders_a50a19dd.id;


--
-- Name: ds_1_test_74ec9ab8; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ds_1_test_74ec9ab8 (
    id integer NOT NULL,
    caseid bigint,
    image_filename text,
    mask_tumor_filename text,
    mask_other_filename text,
    pixel_size double precision,
    age text,
    tissue_composition text,
    signs text,
    symptoms text,
    shape text,
    margin text,
    echogenicity text,
    posterior_features text,
    halo text,
    calcifications text,
    skin_thickening text,
    interpretation text,
    birads text,
    verification text,
    diagnosis text,
    classification text
);


ALTER TABLE public.ds_1_test_74ec9ab8 OWNER TO postgres;

--
-- Name: ds_1_test_74ec9ab8_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ds_1_test_74ec9ab8_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ds_1_test_74ec9ab8_id_seq OWNER TO postgres;

--
-- Name: ds_1_test_74ec9ab8_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ds_1_test_74ec9ab8_id_seq OWNED BY public.ds_1_test_74ec9ab8.id;


--
-- Name: ds_2_products_seed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ds_2_products_seed (
    id integer NOT NULL,
    product_id text,
    name text,
    category text,
    price double precision,
    stock bigint,
    supplier text
);


ALTER TABLE public.ds_2_products_seed OWNER TO postgres;

--
-- Name: ds_2_products_seed_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ds_2_products_seed_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ds_2_products_seed_id_seq OWNER TO postgres;

--
-- Name: ds_2_products_seed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ds_2_products_seed_id_seq OWNED BY public.ds_2_products_seed.id;


--
-- Name: ds_2_sales_seed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ds_2_sales_seed (
    id integer NOT NULL,
    sale_id text,
    product text,
    region text,
    quantity bigint,
    revenue double precision,
    sale_date text,
    rep_name text
);


ALTER TABLE public.ds_2_sales_seed OWNER TO postgres;

--
-- Name: ds_2_sales_seed_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ds_2_sales_seed_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ds_2_sales_seed_id_seq OWNER TO postgres;

--
-- Name: ds_2_sales_seed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ds_2_sales_seed_id_seq OWNED BY public.ds_2_sales_seed.id;


--
-- Name: ds_3_breast_dataset_c6c9cc35; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ds_3_breast_dataset_c6c9cc35 (
    id integer NOT NULL,
    caseid bigint,
    image_filename text,
    mask_tumor_filename text,
    mask_other_filename text,
    pixel_size double precision,
    age text,
    tissue_composition text,
    signs text,
    symptoms text,
    shape text,
    margin text,
    echogenicity text,
    posterior_features text,
    halo text,
    calcifications text,
    skin_thickening text,
    interpretation text,
    birads text,
    verification text,
    diagnosis text,
    classification text
);


ALTER TABLE public.ds_3_breast_dataset_c6c9cc35 OWNER TO postgres;

--
-- Name: ds_3_breast_dataset_c6c9cc35_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ds_3_breast_dataset_c6c9cc35_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ds_3_breast_dataset_c6c9cc35_id_seq OWNER TO postgres;

--
-- Name: ds_3_breast_dataset_c6c9cc35_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ds_3_breast_dataset_c6c9cc35_id_seq OWNED BY public.ds_3_breast_dataset_c6c9cc35.id;


--
-- Name: ds_3_product_inventory_4205c3ea; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ds_3_product_inventory_4205c3ea (
    id integer NOT NULL,
    sku text,
    product_name text,
    category text,
    brand text,
    stock_qty bigint,
    reorder_level bigint,
    unit_cost double precision,
    selling_price double precision,
    warehouse text,
    last_restocked text
);


ALTER TABLE public.ds_3_product_inventory_4205c3ea OWNER TO postgres;

--
-- Name: ds_3_product_inventory_4205c3ea_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ds_3_product_inventory_4205c3ea_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ds_3_product_inventory_4205c3ea_id_seq OWNER TO postgres;

--
-- Name: ds_3_product_inventory_4205c3ea_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ds_3_product_inventory_4205c3ea_id_seq OWNED BY public.ds_3_product_inventory_4205c3ea.id;


--
-- Name: ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8 (
    id integer CONSTRAINT ds_4_breast_lesions_usg_clinical_data_dec_15__52432_id_not_null NOT NULL,
    caseid bigint,
    image_filename text,
    mask_tumor_filename text,
    mask_other_filename text,
    pixel_size double precision,
    age text,
    tissue_composition text,
    signs text,
    symptoms text,
    shape text,
    margin text,
    echogenicity text,
    posterior_features text,
    halo text,
    calcifications text,
    skin_thickening text,
    interpretation text,
    birads text,
    verification text,
    diagnosis text,
    classification text
);


ALTER TABLE public.ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8 OWNER TO postgres;

--
-- Name: ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8_id_seq OWNER TO postgres;

--
-- Name: ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8_id_seq OWNED BY public.ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8.id;


--
-- Name: ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1 (
    id integer CONSTRAINT ds_4_breast_lesions_usg_clinical_data_dec_15__677d4_id_not_null NOT NULL,
    caseid bigint,
    image_filename text,
    mask_tumor_filename text,
    mask_other_filename text,
    pixel_size double precision,
    age text,
    tissue_composition text,
    signs text,
    symptoms text,
    shape text,
    margin text,
    echogenicity text,
    posterior_features text,
    halo text,
    calcifications text,
    skin_thickening text,
    interpretation text,
    birads text,
    verification text,
    diagnosis text,
    classification text
);


ALTER TABLE public.ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1 OWNER TO postgres;

--
-- Name: ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1_id_seq OWNER TO postgres;

--
-- Name: ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1_id_seq OWNED BY public.ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1.id;


--
-- Name: ds_4_product_inventory_0eb0727a; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ds_4_product_inventory_0eb0727a (
    id integer NOT NULL,
    sku text,
    product_name text,
    category text,
    brand text,
    stock_qty bigint,
    reorder_level bigint,
    unit_cost double precision,
    selling_price double precision,
    warehouse text,
    last_restocked text
);


ALTER TABLE public.ds_4_product_inventory_0eb0727a OWNER TO postgres;

--
-- Name: ds_4_product_inventory_0eb0727a_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ds_4_product_inventory_0eb0727a_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ds_4_product_inventory_0eb0727a_id_seq OWNER TO postgres;

--
-- Name: ds_4_product_inventory_0eb0727a_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ds_4_product_inventory_0eb0727a_id_seq OWNED BY public.ds_4_product_inventory_0eb0727a.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    full_name character varying(200) NOT NULL,
    email character varying(255) NOT NULL,
    hashed_password character varying(255),
    plan public.plan NOT NULL,
    is_active boolean NOT NULL,
    is_admin boolean NOT NULL,
    trial_ends_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    google_id character varying(100),
    stripe_customer_id character varying(100),
    stripe_subscription_id character varying(100)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: api_keys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys ALTER COLUMN id SET DEFAULT nextval('public.api_keys_id_seq'::regclass);


--
-- Name: api_usage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_usage ALTER COLUMN id SET DEFAULT nextval('public.api_usage_id_seq'::regclass);


--
-- Name: conversation_messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation_messages ALTER COLUMN id SET DEFAULT nextval('public.conversation_messages_id_seq'::regclass);


--
-- Name: datasets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.datasets ALTER COLUMN id SET DEFAULT nextval('public.datasets_id_seq'::regclass);


--
-- Name: ds_1_employees_seed id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_1_employees_seed ALTER COLUMN id SET DEFAULT nextval('public.ds_1_employees_seed_id_seq'::regclass);


--
-- Name: ds_1_invoices_seed id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_1_invoices_seed ALTER COLUMN id SET DEFAULT nextval('public.ds_1_invoices_seed_id_seq'::regclass);


--
-- Name: ds_1_sales_orders_a50a19dd id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_1_sales_orders_a50a19dd ALTER COLUMN id SET DEFAULT nextval('public.ds_1_sales_orders_a50a19dd_id_seq'::regclass);


--
-- Name: ds_1_test_74ec9ab8 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_1_test_74ec9ab8 ALTER COLUMN id SET DEFAULT nextval('public.ds_1_test_74ec9ab8_id_seq'::regclass);


--
-- Name: ds_2_products_seed id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_2_products_seed ALTER COLUMN id SET DEFAULT nextval('public.ds_2_products_seed_id_seq'::regclass);


--
-- Name: ds_2_sales_seed id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_2_sales_seed ALTER COLUMN id SET DEFAULT nextval('public.ds_2_sales_seed_id_seq'::regclass);


--
-- Name: ds_3_breast_dataset_c6c9cc35 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_3_breast_dataset_c6c9cc35 ALTER COLUMN id SET DEFAULT nextval('public.ds_3_breast_dataset_c6c9cc35_id_seq'::regclass);


--
-- Name: ds_3_product_inventory_4205c3ea id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_3_product_inventory_4205c3ea ALTER COLUMN id SET DEFAULT nextval('public.ds_3_product_inventory_4205c3ea_id_seq'::regclass);


--
-- Name: ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8 ALTER COLUMN id SET DEFAULT nextval('public.ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8_id_seq'::regclass);


--
-- Name: ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1 ALTER COLUMN id SET DEFAULT nextval('public.ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1_id_seq'::regclass);


--
-- Name: ds_4_product_inventory_0eb0727a id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_4_product_inventory_0eb0727a ALTER COLUMN id SET DEFAULT nextval('public.ds_4_product_inventory_0eb0727a_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: api_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_keys (id, user_id, dataset_id, name, key_prefix, key_hash, is_active, last_used_at, created_at, row_filters) FROM stdin;
1	1	1	Customer Invoices — Default Key	docapi_rQSbEhtQp	$2b$12$xWv14Eg9bUmPwPPatekAtO2tpKIe8AlOtUQuJ.K8VcLzSIsklNDru	t	2026-05-10 14:03:01.529353+01	2026-05-13 14:03:01.53091+01	\N
2	2	2	Product Catalog — Default Key	docapi_cTfYrj2xk	$2b$12$DFUgYzrQckq7NoNQEbKaveyO.NXivzHaP1P5EIjQzReVylBrTH.9.	t	2026-05-11 14:03:01.932062+01	2026-05-13 14:03:01.932482+01	\N
3	1	3	Employee Records — Default Key	docapi_kE2QTQEKd	$2b$12$wFWMRb83Wb/zyQxXBvlMp.siD8FcUS84VrB6k6WHvFRL6zHKGbnsi	t	2026-05-10 14:03:02.304119+01	2026-05-13 14:03:02.304598+01	\N
4	2	4	Monthly Sales — Default Key	docapi_Xfk_vgDTk	$2b$12$L6.CiumGgKMUQro7Qi/9v.Ct9qR8yuhO.gqZcVSFODeuDyoRieM3a	t	2026-05-11 14:03:02.69117+01	2026-05-13 14:03:02.691717+01	\N
5	2	\N	Alice — Global Key	docapi_mWiC5qDmw	$2b$12$YI3u4TY.QQLK1IrXWwcPfu6NH5XgCi4AM5IWmVov3555a8USvi2uC	t	2026-05-12 14:03:03.042689+01	2026-05-13 14:03:03.043503+01	\N
7	4	10	brest_cancer	docapi_0AvBEgLBZ	$2b$12$pC9wTP1H2JPDvJOhlFMrh.CtkYjmfBG70y1bqsbkrpjA5gf0RDMz.	f	2026-05-14 23:29:17.351407+01	2026-05-14 23:26:54.057209+01	null
6	4	9	product key	docapi_urEp0_8Oh	$2b$12$3CpgfbS0hQuQwQEx5BBws.uGuL5.sXzLAB34e8o.uG/.ceGPWvLom	f	2026-05-14 22:38:20.448333+01	2026-05-14 22:31:59.240749+01	null
8	4	\N	Test	docapi_4MusmvfpP	$2b$12$tc8lPcsJr5uw/M7wHa.OSeFSFSLeJW2E6Sl2JReNWOEzwl4SZdLNy	t	2026-05-14 23:32:01.44496+01	2026-05-14 23:31:23.649369+01	null
9	1	\N	Test	docapi_4gh-KZg6d	$2b$12$wbRRNOgBZ1d6CZ4NOI28zOoIEL66XN2f13R9bsHPKYApYlXRbKXgq	t	2026-05-14 23:38:54.345264+01	2026-05-14 23:37:09.293321+01	null
\.


--
-- Data for Name: api_usage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_usage (id, api_key_id, dataset_id, method, path, status_code, response_time_ms, created_at, ip_address, query_string) FROM stdin;
1	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	110	2026-05-08 03:04:39.342036+01	\N	\N
2	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	44	2026-05-02 03:30:29.32262+01	\N	\N
3	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	102	2026-04-25 17:45:33.420309+01	\N	\N
4	1	1	GET	/api/v1/ds_1_invoices_seed	404	59	2026-05-05 08:47:30.145588+01	\N	\N
5	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	35	2026-05-01 21:43:38.740522+01	\N	\N
6	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	22	2026-05-10 23:56:45.829393+01	\N	\N
7	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	153	2026-04-19 12:04:01.270667+01	\N	\N
8	1	1	GET	/api/v1/ds_1_invoices_seed	200	262	2026-05-12 01:25:35.489235+01	\N	\N
9	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	89	2026-04-24 11:09:51.454796+01	\N	\N
10	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	104	2026-05-07 17:55:30.021909+01	\N	\N
11	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	404	46	2026-04-22 04:20:36.311964+01	\N	\N
12	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	240	2026-04-23 23:46:58.074065+01	\N	\N
13	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	178	2026-05-02 07:36:39.917805+01	\N	\N
14	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	404	51	2026-05-06 16:18:12.457913+01	\N	\N
15	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	149	2026-04-20 19:11:53.713605+01	\N	\N
16	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	240	2026-05-03 09:12:42.753819+01	\N	\N
17	1	1	GET	/api/v1/ds_1_invoices_seed	200	68	2026-04-20 06:33:31.150092+01	\N	\N
18	1	1	GET	/api/v1/ds_1_invoices_seed	200	143	2026-04-23 02:26:20.276522+01	\N	\N
19	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	82	2026-05-04 00:50:12.232296+01	\N	\N
20	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	85	2026-04-14 03:26:50.80486+01	\N	\N
21	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	90	2026-04-16 08:39:30.677579+01	\N	\N
22	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	71	2026-05-08 11:54:55.388436+01	\N	\N
23	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	80	2026-05-12 21:58:17.421944+01	\N	\N
24	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	404	272	2026-05-09 13:04:21.286715+01	\N	\N
25	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	192	2026-04-27 05:38:46.688301+01	\N	\N
26	1	1	GET	/api/v1/ds_1_invoices_seed	200	174	2026-04-14 04:15:40.088132+01	\N	\N
27	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	82	2026-05-10 23:45:38.902256+01	\N	\N
28	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	55	2026-05-10 15:30:10.122151+01	\N	\N
29	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	264	2026-04-25 04:01:48.438279+01	\N	\N
30	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	164	2026-05-04 17:33:00.481495+01	\N	\N
31	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	30	2026-04-23 22:04:36.240146+01	\N	\N
32	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	261	2026-05-05 08:47:15.868061+01	\N	\N
33	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	115	2026-05-06 12:10:46.637696+01	\N	\N
34	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	404	43	2026-05-11 22:51:30.265974+01	\N	\N
35	1	1	GET	/api/v1/ds_1_invoices_seed	200	107	2026-05-10 08:11:44.334432+01	\N	\N
36	1	1	GET	/api/v1/ds_1_invoices_seed	200	276	2026-04-16 18:05:42.317043+01	\N	\N
37	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	48	2026-04-27 06:57:14.435855+01	\N	\N
38	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	211	2026-04-27 05:22:16.60212+01	\N	\N
39	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	108	2026-04-25 10:25:46.560285+01	\N	\N
40	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	216	2026-05-02 20:03:14.777957+01	\N	\N
41	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	131	2026-04-22 23:29:30.8019+01	\N	\N
42	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	199	2026-04-18 10:14:15.015495+01	\N	\N
43	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	158	2026-05-11 02:44:57.791503+01	\N	\N
44	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	272	2026-05-05 11:18:41.469987+01	\N	\N
45	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	92	2026-04-20 11:59:07.033008+01	\N	\N
46	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	32	2026-05-09 16:27:39.672856+01	\N	\N
47	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	202	2026-04-21 13:46:08.923023+01	\N	\N
48	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	199	2026-05-02 20:58:54.812195+01	\N	\N
49	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	280	2026-05-01 18:45:11.535767+01	\N	\N
50	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	182	2026-04-15 16:06:37.704494+01	\N	\N
51	1	1	GET	/api/v1/ds_1_invoices_seed/schema	404	43	2026-04-23 00:14:28.014131+01	\N	\N
52	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	213	2026-05-07 15:01:08.973321+01	\N	\N
53	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	76	2026-04-20 19:15:55.40602+01	\N	\N
54	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	24	2026-05-11 11:32:08.475213+01	\N	\N
55	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	12	2026-04-29 01:07:34.122783+01	\N	\N
56	1	1	GET	/api/v1/ds_1_invoices_seed	200	262	2026-05-02 12:14:37.760937+01	\N	\N
57	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	26	2026-04-26 07:20:06.807016+01	\N	\N
58	1	1	GET	/api/v1/ds_1_invoices_seed	200	10	2026-04-28 23:48:05.565374+01	\N	\N
59	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	116	2026-05-11 08:34:52.557638+01	\N	\N
60	1	1	GET	/api/v1/ds_1_invoices_seed	200	58	2026-05-04 12:48:37.916363+01	\N	\N
61	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	120	2026-05-08 18:27:58.86309+01	\N	\N
62	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	218	2026-04-17 04:37:32.312445+01	\N	\N
63	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	154	2026-04-22 09:05:15.722049+01	\N	\N
64	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	252	2026-04-24 16:37:07.520664+01	\N	\N
65	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	226	2026-04-20 00:00:25.954743+01	\N	\N
66	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	198	2026-05-13 09:07:07.317484+01	\N	\N
67	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	127	2026-04-26 03:01:41.131586+01	\N	\N
68	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	83	2026-04-29 11:59:56.603212+01	\N	\N
69	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	103	2026-04-19 11:54:06.089989+01	\N	\N
70	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	99	2026-05-09 06:57:46.792093+01	\N	\N
71	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	214	2026-04-21 04:47:29.844823+01	\N	\N
72	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	15	2026-04-28 16:06:13.885507+01	\N	\N
73	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	82	2026-05-11 15:22:16.172895+01	\N	\N
74	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	193	2026-04-25 06:52:08.503032+01	\N	\N
75	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	244	2026-05-08 01:12:12.585941+01	\N	\N
76	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	96	2026-05-12 11:11:00.526927+01	\N	\N
77	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	24	2026-05-07 13:03:25.62296+01	\N	\N
78	1	1	GET	/api/v1/ds_1_invoices_seed	200	222	2026-05-02 19:14:35.955059+01	\N	\N
79	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	106	2026-04-15 09:09:20.907375+01	\N	\N
80	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	79	2026-05-10 05:36:03.749372+01	\N	\N
81	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	79	2026-04-18 09:41:27.889363+01	\N	\N
82	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	110	2026-05-11 01:37:40.123934+01	\N	\N
83	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	46	2026-05-09 13:22:21.958686+01	\N	\N
84	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	109	2026-05-01 01:39:51.210126+01	\N	\N
85	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	198	2026-04-26 09:32:42.687152+01	\N	\N
86	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	198	2026-04-24 11:45:07.397323+01	\N	\N
87	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	261	2026-04-15 12:09:41.902906+01	\N	\N
88	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	232	2026-05-13 03:33:05.560608+01	\N	\N
89	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	114	2026-04-14 22:45:35.365365+01	\N	\N
90	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	278	2026-04-20 13:44:58.212008+01	\N	\N
91	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	260	2026-04-16 18:49:48.314212+01	\N	\N
92	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	242	2026-05-05 00:42:43.803074+01	\N	\N
93	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	73	2026-04-13 23:10:31.146565+01	\N	\N
94	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	81	2026-05-12 22:48:21.549517+01	\N	\N
95	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	403	223	2026-04-28 00:00:06.640081+01	\N	\N
96	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	105	2026-05-09 21:36:52.720154+01	\N	\N
97	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	34	2026-05-12 09:34:00.902242+01	\N	\N
98	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	246	2026-05-01 15:32:13.334042+01	\N	\N
99	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	200	2026-04-16 11:18:53.465932+01	\N	\N
100	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	98	2026-05-09 16:45:05.689279+01	\N	\N
101	1	1	GET	/api/v1/ds_1_invoices_seed	200	112	2026-04-16 10:23:36.973668+01	\N	\N
102	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	53	2026-04-17 13:01:32.121265+01	\N	\N
103	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	276	2026-05-10 13:09:46.846607+01	\N	\N
104	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	215	2026-04-18 00:18:22.727211+01	\N	\N
105	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	165	2026-04-22 09:45:27.316037+01	\N	\N
106	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	62	2026-05-11 03:09:47.796507+01	\N	\N
107	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	164	2026-04-18 07:37:09.007241+01	\N	\N
108	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	45	2026-04-14 22:04:39.367657+01	\N	\N
109	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	93	2026-05-11 02:25:35.08241+01	\N	\N
110	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	404	211	2026-05-04 13:16:01.592321+01	\N	\N
111	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	242	2026-04-29 21:51:56.259224+01	\N	\N
112	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	52	2026-05-12 18:27:52.701708+01	\N	\N
113	1	1	GET	/api/v1/ds_1_invoices_seed	200	14	2026-05-10 04:22:38.762902+01	\N	\N
114	1	1	GET	/api/v1/ds_1_invoices_seed	200	142	2026-04-30 11:58:35.813468+01	\N	\N
115	1	1	GET	/api/v1/ds_1_invoices_seed	200	124	2026-05-05 14:34:15.477407+01	\N	\N
116	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	57	2026-04-20 04:22:15.125326+01	\N	\N
117	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	135	2026-04-29 01:08:50.614363+01	\N	\N
118	1	1	GET	/api/v1/ds_1_invoices_seed	200	201	2026-04-20 03:07:41.669716+01	\N	\N
119	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	17	2026-04-24 11:40:41.285749+01	\N	\N
120	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	245	2026-04-15 02:19:14.704813+01	\N	\N
121	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	40	2026-05-10 14:00:41.340667+01	\N	\N
122	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	222	2026-04-18 06:55:48.131208+01	\N	\N
123	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	180	2026-05-08 22:19:20.158873+01	\N	\N
124	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	404	262	2026-05-07 16:57:10.502383+01	\N	\N
125	1	1	GET	/api/v1/ds_1_invoices_seed	200	108	2026-04-21 12:55:40.959399+01	\N	\N
126	1	1	GET	/api/v1/ds_1_invoices_seed	200	75	2026-04-30 21:07:39.312634+01	\N	\N
127	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	234	2026-05-01 13:37:25.44539+01	\N	\N
128	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	100	2026-04-30 10:59:59.654998+01	\N	\N
129	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	49	2026-04-20 03:59:16.365227+01	\N	\N
130	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	249	2026-04-20 18:57:41.893863+01	\N	\N
131	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	160	2026-05-01 13:30:30.689992+01	\N	\N
132	1	1	GET	/api/v1/ds_1_invoices_seed	200	249	2026-04-28 09:27:21.335122+01	\N	\N
133	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	136	2026-04-28 17:44:39.701841+01	\N	\N
134	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	269	2026-05-09 20:38:31.489624+01	\N	\N
135	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	274	2026-04-26 23:05:30.776842+01	\N	\N
136	1	1	GET	/api/v1/ds_1_invoices_seed	200	230	2026-05-07 12:15:38.58136+01	\N	\N
137	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	73	2026-05-03 20:24:37.152096+01	\N	\N
138	1	1	GET	/api/v1/ds_1_invoices_seed/schema	403	248	2026-05-03 01:45:50.305495+01	\N	\N
139	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	80	2026-05-06 08:23:31.637126+01	\N	\N
140	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	227	2026-05-09 14:36:51.381331+01	\N	\N
141	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	253	2026-05-04 11:49:19.627778+01	\N	\N
142	1	1	GET	/api/v1/ds_1_invoices_seed	200	143	2026-04-27 04:28:16.267714+01	\N	\N
143	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	201	2026-04-17 11:03:47.287536+01	\N	\N
144	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	33	2026-04-25 14:43:56.485211+01	\N	\N
145	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	176	2026-05-06 21:04:54.04111+01	\N	\N
146	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	130	2026-04-25 19:35:43.411778+01	\N	\N
147	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	274	2026-04-30 19:14:24.025523+01	\N	\N
148	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	51	2026-04-26 13:22:41.731787+01	\N	\N
149	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	231	2026-05-13 03:45:15.928038+01	\N	\N
150	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	211	2026-05-08 07:08:32.250667+01	\N	\N
151	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	275	2026-04-13 18:44:13.583884+01	\N	\N
152	1	1	GET	/api/v1/ds_1_invoices_seed	200	244	2026-05-06 23:12:02.06234+01	\N	\N
153	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	34	2026-05-12 08:32:57.484414+01	\N	\N
154	1	1	GET	/api/v1/ds_1_invoices_seed	200	82	2026-05-08 09:01:32.551021+01	\N	\N
155	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	31	2026-05-12 23:49:03.851361+01	\N	\N
156	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	204	2026-04-24 12:27:50.230517+01	\N	\N
157	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	125	2026-04-17 09:11:52.327777+01	\N	\N
158	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	280	2026-05-01 02:34:46.172587+01	\N	\N
159	1	1	GET	/api/v1/ds_1_invoices_seed	404	11	2026-04-26 00:31:38.921108+01	\N	\N
160	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	130	2026-04-17 20:14:51.813915+01	\N	\N
161	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	186	2026-04-19 00:08:07.946905+01	\N	\N
162	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	163	2026-04-29 10:28:15.105316+01	\N	\N
163	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	150	2026-04-22 10:34:03.973266+01	\N	\N
164	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	169	2026-04-20 22:37:42.560523+01	\N	\N
165	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	257	2026-04-26 08:23:19.158566+01	\N	\N
166	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	273	2026-04-23 23:21:55.129681+01	\N	\N
167	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	128	2026-04-21 19:29:49.985675+01	\N	\N
168	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	216	2026-04-28 13:07:48.067302+01	\N	\N
169	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	404	105	2026-04-19 15:41:06.719781+01	\N	\N
170	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	263	2026-04-16 07:16:57.628234+01	\N	\N
171	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	213	2026-04-18 18:45:11.605619+01	\N	\N
172	1	1	GET	/api/v1/ds_1_invoices_seed	200	42	2026-04-29 11:53:31.820751+01	\N	\N
173	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	192	2026-04-19 18:38:00.731129+01	\N	\N
174	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	153	2026-05-12 22:01:40.195859+01	\N	\N
175	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	170	2026-05-03 21:34:00.111328+01	\N	\N
176	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	166	2026-05-09 10:14:48.694229+01	\N	\N
177	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	252	2026-04-23 19:24:29.072206+01	\N	\N
178	1	1	GET	/api/v1/ds_1_invoices_seed	200	249	2026-04-23 00:41:58.035489+01	\N	\N
179	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	130	2026-04-24 01:49:21.095091+01	\N	\N
180	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	261	2026-04-15 21:29:05.711795+01	\N	\N
181	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	93	2026-04-16 20:39:54.782073+01	\N	\N
182	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	158	2026-05-06 00:27:12.365964+01	\N	\N
183	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	264	2026-04-16 23:29:12.022729+01	\N	\N
184	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	103	2026-04-21 12:34:04.89628+01	\N	\N
185	1	1	GET	/api/v1/ds_1_invoices_seed	200	231	2026-04-27 20:07:31.458951+01	\N	\N
186	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	211	2026-04-30 04:35:10.779262+01	\N	\N
187	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	264	2026-05-09 02:32:56.744494+01	\N	\N
188	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	126	2026-04-28 07:26:30.551588+01	\N	\N
189	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	193	2026-05-01 12:12:05.450881+01	\N	\N
190	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	22	2026-04-22 04:34:28.315604+01	\N	\N
191	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	225	2026-04-30 17:53:31.53751+01	\N	\N
192	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	196	2026-05-13 12:14:11.751096+01	\N	\N
193	1	1	GET	/api/v1/ds_1_invoices_seed	403	85	2026-05-13 12:02:15.320357+01	\N	\N
194	1	1	GET	/api/v1/ds_1_invoices_seed	200	117	2026-05-04 00:47:54.705516+01	\N	\N
195	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	207	2026-05-02 22:40:05.688871+01	\N	\N
196	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	141	2026-04-21 12:23:36.834831+01	\N	\N
197	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	266	2026-04-25 10:06:46.922446+01	\N	\N
198	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	189	2026-05-02 19:42:15.931875+01	\N	\N
199	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	157	2026-04-27 02:22:15.167258+01	\N	\N
200	1	1	GET	/api/v1/ds_1_invoices_seed	200	12	2026-05-07 00:48:01.321327+01	\N	\N
201	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	248	2026-05-10 23:30:48.381062+01	\N	\N
202	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	253	2026-04-15 12:54:29.674626+01	\N	\N
203	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	94	2026-05-10 07:07:39.424225+01	\N	\N
204	1	1	GET	/api/v1/ds_1_invoices_seed	200	120	2026-05-09 13:54:53.411274+01	\N	\N
205	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	62	2026-04-15 15:43:06.284763+01	\N	\N
206	1	1	GET	/api/v1/ds_1_invoices_seed	200	101	2026-04-23 16:35:12.687594+01	\N	\N
207	1	1	GET	/api/v1/ds_1_invoices_seed	200	188	2026-04-27 15:54:12.534796+01	\N	\N
208	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	185	2026-04-23 09:23:50.173926+01	\N	\N
209	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	44	2026-04-24 22:07:22.92225+01	\N	\N
210	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	69	2026-05-07 08:07:53.062907+01	\N	\N
211	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	77	2026-04-20 03:51:07.186261+01	\N	\N
212	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	241	2026-05-03 04:21:35.854014+01	\N	\N
213	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	171	2026-05-06 07:12:54.216429+01	\N	\N
214	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	273	2026-04-24 12:27:45.729818+01	\N	\N
215	1	1	GET	/api/v1/ds_1_invoices_seed	200	86	2026-04-28 18:12:58.444798+01	\N	\N
216	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	166	2026-05-03 15:54:20.965352+01	\N	\N
217	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	127	2026-04-28 08:10:39.203149+01	\N	\N
218	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	164	2026-05-11 10:02:12.771524+01	\N	\N
219	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	75	2026-05-05 15:28:55.367945+01	\N	\N
220	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	264	2026-05-07 16:42:19.209695+01	\N	\N
221	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	20	2026-05-02 19:16:49.023933+01	\N	\N
222	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	45	2026-05-08 18:18:12.228507+01	\N	\N
223	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	174	2026-05-12 23:59:08.465611+01	\N	\N
224	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	180	2026-05-04 06:45:39.88894+01	\N	\N
225	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	98	2026-04-22 04:55:56.103336+01	\N	\N
226	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	278	2026-05-07 18:44:18.529713+01	\N	\N
227	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	60	2026-05-10 13:56:44.456901+01	\N	\N
228	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	194	2026-05-06 20:56:25.41751+01	\N	\N
229	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	125	2026-04-19 14:48:13.984762+01	\N	\N
230	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	91	2026-04-19 07:11:32.738659+01	\N	\N
231	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	404	231	2026-04-14 06:26:48.253954+01	\N	\N
232	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	197	2026-04-20 17:51:25.981782+01	\N	\N
233	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	215	2026-04-18 23:01:04.804864+01	\N	\N
234	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	35	2026-05-04 19:14:30.249533+01	\N	\N
235	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	269	2026-04-27 04:32:48.930855+01	\N	\N
236	1	1	GET	/api/v1/ds_1_invoices_seed	200	241	2026-04-25 21:55:13.400945+01	\N	\N
237	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	10	2026-04-18 02:47:07.491996+01	\N	\N
238	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	85	2026-05-08 18:18:54.867169+01	\N	\N
239	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	138	2026-04-16 17:35:39.275834+01	\N	\N
240	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	194	2026-05-13 03:04:11.030776+01	\N	\N
241	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	147	2026-05-12 02:26:23.268335+01	\N	\N
242	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	26	2026-04-21 17:10:23.792439+01	\N	\N
243	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	247	2026-05-12 03:49:44.003218+01	\N	\N
244	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	234	2026-05-05 06:41:27.578804+01	\N	\N
245	1	1	GET	/api/v1/ds_1_invoices_seed/1	404	29	2026-04-21 17:42:53.520205+01	\N	\N
246	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	250	2026-05-08 14:29:58.358429+01	\N	\N
247	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	256	2026-04-28 19:17:23.686224+01	\N	\N
248	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	278	2026-05-11 06:11:57.326279+01	\N	\N
249	1	1	GET	/api/v1/ds_1_invoices_seed	200	127	2026-05-09 02:37:01.996411+01	\N	\N
250	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	75	2026-04-15 20:32:39.530241+01	\N	\N
251	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	69	2026-05-05 11:37:44.164303+01	\N	\N
252	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	190	2026-05-10 21:52:32.796103+01	\N	\N
253	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	264	2026-04-15 08:59:59.068294+01	\N	\N
254	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	54	2026-05-09 07:44:21.449557+01	\N	\N
255	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	403	167	2026-04-30 06:10:15.342158+01	\N	\N
256	1	1	GET	/api/v1/ds_1_invoices_seed	200	262	2026-04-16 00:49:48.988711+01	\N	\N
257	1	1	GET	/api/v1/ds_1_invoices_seed	200	272	2026-04-30 20:05:47.645314+01	\N	\N
258	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	129	2026-04-22 11:07:50.082781+01	\N	\N
259	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	250	2026-05-12 13:22:54.974561+01	\N	\N
260	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	9	2026-04-18 23:38:55.315743+01	\N	\N
261	1	1	GET	/api/v1/ds_1_invoices_seed/1	404	146	2026-04-19 08:30:00.964208+01	\N	\N
262	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	138	2026-05-06 09:56:28.797686+01	\N	\N
263	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	160	2026-05-13 07:36:36.225796+01	\N	\N
264	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	155	2026-05-04 16:59:32.247739+01	\N	\N
265	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	58	2026-05-10 08:17:36.740648+01	\N	\N
266	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	148	2026-04-25 23:42:32.251215+01	\N	\N
267	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	200	2026-04-18 15:47:45.192932+01	\N	\N
268	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	90	2026-04-23 12:53:45.613052+01	\N	\N
269	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	262	2026-04-16 03:13:42.245032+01	\N	\N
270	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	139	2026-05-07 08:39:45.275108+01	\N	\N
271	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	104	2026-04-23 20:29:52.523802+01	\N	\N
272	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	217	2026-05-09 08:44:00.186295+01	\N	\N
273	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	404	158	2026-04-27 07:14:45.276759+01	\N	\N
274	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	403	267	2026-05-09 06:08:43.74018+01	\N	\N
275	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	216	2026-04-18 15:26:53.42418+01	\N	\N
276	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	403	268	2026-04-23 21:57:34.989607+01	\N	\N
277	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	42	2026-04-28 14:41:33.377399+01	\N	\N
278	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	165	2026-04-29 13:06:10.683976+01	\N	\N
279	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	43	2026-04-16 12:35:46.297576+01	\N	\N
280	1	1	GET	/api/v1/ds_1_invoices_seed	200	36	2026-04-26 14:12:47.515866+01	\N	\N
281	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	63	2026-04-25 11:25:48.429698+01	\N	\N
282	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	90	2026-05-09 12:31:26.513388+01	\N	\N
283	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	134	2026-04-24 16:49:39.517242+01	\N	\N
284	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	268	2026-05-06 08:49:30.622794+01	\N	\N
285	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	170	2026-05-03 19:01:08.81042+01	\N	\N
286	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	277	2026-05-07 03:19:12.970748+01	\N	\N
287	1	1	GET	/api/v1/ds_1_invoices_seed	200	166	2026-05-10 04:54:54.70351+01	\N	\N
288	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	245	2026-04-18 03:30:02.871624+01	\N	\N
289	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	103	2026-05-13 01:45:06.61882+01	\N	\N
290	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	113	2026-05-09 04:48:57.014491+01	\N	\N
291	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	263	2026-05-10 18:50:59.215605+01	\N	\N
292	1	1	GET	/api/v1/ds_1_invoices_seed	200	198	2026-04-29 13:39:04.305799+01	\N	\N
293	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	260	2026-05-10 21:47:29.77844+01	\N	\N
294	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	8	2026-04-25 13:27:52.072446+01	\N	\N
295	1	1	GET	/api/v1/ds_1_invoices_seed	200	76	2026-04-30 10:37:59.780295+01	\N	\N
296	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	98	2026-04-26 22:53:35.701533+01	\N	\N
297	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	183	2026-04-16 03:48:59.44936+01	\N	\N
298	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	135	2026-05-09 12:26:56.767624+01	\N	\N
299	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	404	58	2026-05-08 05:49:59.051232+01	\N	\N
300	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	209	2026-04-20 05:02:09.908606+01	\N	\N
301	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	9	2026-05-06 21:33:54.118283+01	\N	\N
302	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	58	2026-04-27 16:30:33.692476+01	\N	\N
303	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	121	2026-04-29 07:51:17.811235+01	\N	\N
304	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	141	2026-05-01 01:31:06.429527+01	\N	\N
305	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	38	2026-04-14 19:48:16.166256+01	\N	\N
306	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	103	2026-05-04 15:28:34.580203+01	\N	\N
307	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	70	2026-05-06 08:03:05.261856+01	\N	\N
308	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	192	2026-04-21 23:01:41.497412+01	\N	\N
309	1	1	GET	/api/v1/ds_1_invoices_seed	200	145	2026-04-30 14:15:24.326328+01	\N	\N
310	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	268	2026-05-11 09:49:22.143463+01	\N	\N
311	1	1	GET	/api/v1/ds_1_invoices_seed	200	112	2026-04-19 23:13:06.357831+01	\N	\N
312	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	177	2026-05-07 09:56:55.740763+01	\N	\N
313	1	1	GET	/api/v1/ds_1_invoices_seed	200	58	2026-04-30 21:40:56.218211+01	\N	\N
314	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	23	2026-05-07 06:18:27.509323+01	\N	\N
315	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	274	2026-04-14 03:04:00.539832+01	\N	\N
316	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	107	2026-05-13 03:37:08.528893+01	\N	\N
317	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	243	2026-04-18 06:14:29.026771+01	\N	\N
318	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	71	2026-05-03 09:38:59.371396+01	\N	\N
319	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	209	2026-04-25 03:31:38.306924+01	\N	\N
320	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	100	2026-05-02 12:34:26.639579+01	\N	\N
321	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	34	2026-04-28 16:25:31.048801+01	\N	\N
322	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	166	2026-04-23 06:25:55.279739+01	\N	\N
323	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	221	2026-04-30 20:05:24.879846+01	\N	\N
324	1	1	GET	/api/v1/ds_1_invoices_seed	200	230	2026-04-22 18:35:18.555983+01	\N	\N
325	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	185	2026-04-25 17:33:19.230394+01	\N	\N
326	1	1	GET	/api/v1/ds_1_invoices_seed?region=Europe	200	137	2026-05-09 07:21:05.675438+01	\N	\N
327	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	180	2026-04-20 17:51:01.84441+01	\N	\N
328	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	89	2026-04-20 08:34:08.200658+01	\N	\N
329	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	218	2026-04-14 13:07:53.792094+01	\N	\N
330	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	79	2026-04-19 08:19:39.474304+01	\N	\N
331	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	36	2026-04-25 19:21:07.199255+01	\N	\N
332	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	9	2026-05-01 20:34:05.745969+01	\N	\N
333	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	43	2026-04-18 11:47:37.405526+01	\N	\N
334	1	1	GET	/api/v1/ds_1_invoices_seed?page=2	200	92	2026-04-19 01:34:57.323682+01	\N	\N
335	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	154	2026-04-19 04:19:44.618237+01	\N	\N
336	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	48	2026-04-15 23:01:23.574262+01	\N	\N
337	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	132	2026-04-27 19:53:35.805662+01	\N	\N
338	1	1	GET	/api/v1/ds_1_invoices_seed/schema	200	75	2026-05-04 12:52:05.192027+01	\N	\N
339	1	1	GET	/api/v1/ds_1_invoices_seed/1	200	237	2026-05-07 17:11:34.606256+01	\N	\N
340	1	1	GET	/api/v1/ds_1_invoices_seed?status=paid	200	126	2026-05-10 15:34:27.407851+01	\N	\N
341	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	138	2026-05-05 08:44:20.266923+01	\N	\N
342	2	2	GET	/api/v1/ds_2_products_seed/1	200	28	2026-04-26 04:47:17.007254+01	\N	\N
343	2	2	GET	/api/v1/ds_2_products_seed	200	262	2026-04-28 12:20:02.195812+01	\N	\N
344	2	2	GET	/api/v1/ds_2_products_seed	200	274	2026-04-23 05:45:04.059054+01	\N	\N
345	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	279	2026-04-25 20:22:47.955933+01	\N	\N
346	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	162	2026-05-07 03:21:06.525311+01	\N	\N
347	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	279	2026-04-21 05:36:51.267632+01	\N	\N
348	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	175	2026-05-07 19:31:39.468271+01	\N	\N
349	2	2	GET	/api/v1/ds_2_products_seed	200	257	2026-04-15 20:02:27.813252+01	\N	\N
350	2	2	GET	/api/v1/ds_2_products_seed/schema	200	200	2026-04-29 21:32:37.459801+01	\N	\N
351	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	243	2026-04-26 16:00:23.205857+01	\N	\N
352	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	61	2026-04-19 18:34:26.543774+01	\N	\N
353	2	2	GET	/api/v1/ds_2_products_seed/1	200	76	2026-05-02 06:11:41.650036+01	\N	\N
354	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	108	2026-04-28 01:20:16.162932+01	\N	\N
355	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	210	2026-04-25 06:28:52.304916+01	\N	\N
356	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	201	2026-04-27 16:22:28.090113+01	\N	\N
357	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	161	2026-04-29 09:51:32.275455+01	\N	\N
358	2	2	GET	/api/v1/ds_2_products_seed	200	214	2026-05-12 09:19:58.742021+01	\N	\N
359	2	2	GET	/api/v1/ds_2_products_seed/1	200	216	2026-04-27 10:05:39.886593+01	\N	\N
360	2	2	GET	/api/v1/ds_2_products_seed	200	38	2026-05-03 15:14:55.546227+01	\N	\N
361	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	265	2026-05-08 21:11:00.939285+01	\N	\N
362	2	2	GET	/api/v1/ds_2_products_seed/schema	200	101	2026-04-25 04:08:13.806759+01	\N	\N
363	2	2	GET	/api/v1/ds_2_products_seed/schema	200	91	2026-04-22 07:52:26.588003+01	\N	\N
364	2	2	GET	/api/v1/ds_2_products_seed	200	82	2026-05-01 09:32:19.051034+01	\N	\N
365	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	218	2026-04-15 02:20:45.090534+01	\N	\N
366	2	2	GET	/api/v1/ds_2_products_seed/1	200	80	2026-04-27 02:57:41.822339+01	\N	\N
367	2	2	GET	/api/v1/ds_2_products_seed/schema	200	172	2026-05-10 15:45:35.997393+01	\N	\N
368	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	52	2026-04-14 08:20:11.341092+01	\N	\N
369	2	2	GET	/api/v1/ds_2_products_seed/1	200	21	2026-05-03 18:57:40.272603+01	\N	\N
370	2	2	GET	/api/v1/ds_2_products_seed	200	28	2026-05-02 06:57:44.51477+01	\N	\N
371	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	267	2026-04-30 21:08:24.022748+01	\N	\N
372	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	269	2026-04-25 07:02:33.75707+01	\N	\N
373	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	200	2026-04-19 21:20:00.447661+01	\N	\N
374	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	62	2026-05-12 14:33:31.301526+01	\N	\N
375	2	2	GET	/api/v1/ds_2_products_seed/schema	200	53	2026-04-30 13:25:30.40436+01	\N	\N
376	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	90	2026-04-25 15:39:28.543413+01	\N	\N
377	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	404	258	2026-05-06 14:36:51.52216+01	\N	\N
378	2	2	GET	/api/v1/ds_2_products_seed/schema	200	74	2026-04-14 17:36:56.74892+01	\N	\N
379	2	2	GET	/api/v1/ds_2_products_seed/schema	200	210	2026-04-17 13:48:30.689108+01	\N	\N
380	2	2	GET	/api/v1/ds_2_products_seed	200	228	2026-04-29 08:05:35.293653+01	\N	\N
381	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	240	2026-05-12 03:23:54.893004+01	\N	\N
382	2	2	GET	/api/v1/ds_2_products_seed	200	229	2026-05-06 07:44:43.146877+01	\N	\N
383	2	2	GET	/api/v1/ds_2_products_seed/1	200	133	2026-04-18 19:04:01.029681+01	\N	\N
384	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	174	2026-04-25 01:38:39.099754+01	\N	\N
385	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	16	2026-05-07 18:41:45.545915+01	\N	\N
386	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	68	2026-04-14 18:57:29.728813+01	\N	\N
387	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	206	2026-04-13 22:00:25.718678+01	\N	\N
388	2	2	GET	/api/v1/ds_2_products_seed	200	76	2026-04-16 00:10:23.574425+01	\N	\N
389	2	2	GET	/api/v1/ds_2_products_seed	200	129	2026-05-05 04:25:30.602411+01	\N	\N
390	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	73	2026-05-01 02:24:58.377644+01	\N	\N
391	2	2	GET	/api/v1/ds_2_products_seed/1	200	186	2026-04-21 07:19:13.404027+01	\N	\N
392	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	205	2026-04-30 03:23:21.637499+01	\N	\N
393	2	2	GET	/api/v1/ds_2_products_seed/schema	200	52	2026-05-06 22:31:52.087115+01	\N	\N
394	2	2	GET	/api/v1/ds_2_products_seed	200	114	2026-05-10 16:04:52.801203+01	\N	\N
395	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	185	2026-04-24 06:17:42.543615+01	\N	\N
396	2	2	GET	/api/v1/ds_2_products_seed/1	200	82	2026-05-06 03:34:01.916097+01	\N	\N
397	2	2	GET	/api/v1/ds_2_products_seed	200	76	2026-04-23 07:20:33.608458+01	\N	\N
398	2	2	GET	/api/v1/ds_2_products_seed/schema	200	259	2026-04-21 10:55:40.065887+01	\N	\N
399	2	2	GET	/api/v1/ds_2_products_seed/schema	200	44	2026-04-15 21:20:25.99501+01	\N	\N
400	2	2	GET	/api/v1/ds_2_products_seed/schema	200	16	2026-04-24 03:43:19.110991+01	\N	\N
401	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	167	2026-04-19 05:08:56.65896+01	\N	\N
402	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	211	2026-05-10 10:28:52.169323+01	\N	\N
403	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	114	2026-05-04 17:11:26.127619+01	\N	\N
404	2	2	GET	/api/v1/ds_2_products_seed?page=2	404	233	2026-05-09 09:26:15.195004+01	\N	\N
405	2	2	GET	/api/v1/ds_2_products_seed/schema	200	259	2026-05-08 11:26:26.104401+01	\N	\N
406	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	176	2026-04-23 06:12:07.1323+01	\N	\N
407	2	2	GET	/api/v1/ds_2_products_seed/1	200	13	2026-05-02 08:29:12.521673+01	\N	\N
408	2	2	GET	/api/v1/ds_2_products_seed	200	186	2026-05-04 01:16:34.655716+01	\N	\N
409	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	251	2026-04-28 07:19:36.061036+01	\N	\N
410	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	25	2026-05-03 00:00:13.713972+01	\N	\N
411	2	2	GET	/api/v1/ds_2_products_seed/schema	200	273	2026-04-24 16:21:35.77777+01	\N	\N
412	2	2	GET	/api/v1/ds_2_products_seed?page=2	404	256	2026-04-29 18:26:32.884793+01	\N	\N
413	2	2	GET	/api/v1/ds_2_products_seed/schema	200	52	2026-04-24 13:04:57.877907+01	\N	\N
414	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	183	2026-04-23 15:14:25.532907+01	\N	\N
415	2	2	GET	/api/v1/ds_2_products_seed/1	200	131	2026-05-12 12:54:14.903168+01	\N	\N
416	2	2	GET	/api/v1/ds_2_products_seed/1	200	26	2026-04-23 18:25:19.025543+01	\N	\N
417	2	2	GET	/api/v1/ds_2_products_seed	200	10	2026-05-13 05:40:58.153157+01	\N	\N
418	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	211	2026-05-11 20:41:57.98752+01	\N	\N
419	2	2	GET	/api/v1/ds_2_products_seed/schema	200	190	2026-05-12 04:50:17.189688+01	\N	\N
420	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	159	2026-04-25 00:45:05.132711+01	\N	\N
421	2	2	GET	/api/v1/ds_2_products_seed/1	200	115	2026-05-02 17:10:12.845616+01	\N	\N
422	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	246	2026-04-16 15:16:37.590614+01	\N	\N
423	2	2	GET	/api/v1/ds_2_products_seed	200	66	2026-05-02 04:21:54.058861+01	\N	\N
424	2	2	GET	/api/v1/ds_2_products_seed?status=paid	403	209	2026-05-02 07:33:31.720212+01	\N	\N
425	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	11	2026-05-06 13:29:20.31184+01	\N	\N
426	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	256	2026-04-15 09:34:29.664228+01	\N	\N
427	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	114	2026-05-05 02:24:30.849515+01	\N	\N
428	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	85	2026-04-22 00:59:37.652884+01	\N	\N
429	2	2	GET	/api/v1/ds_2_products_seed/1	200	265	2026-04-15 20:53:04.961353+01	\N	\N
430	2	2	GET	/api/v1/ds_2_products_seed/schema	200	114	2026-04-14 01:42:03.928391+01	\N	\N
431	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	191	2026-04-19 08:08:26.963328+01	\N	\N
432	2	2	GET	/api/v1/ds_2_products_seed/1	403	92	2026-05-01 21:58:55.893097+01	\N	\N
433	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	123	2026-05-04 08:36:59.982227+01	\N	\N
434	2	2	GET	/api/v1/ds_2_products_seed	200	129	2026-05-10 16:12:09.242446+01	\N	\N
435	2	2	GET	/api/v1/ds_2_products_seed	200	10	2026-05-09 02:22:01.911152+01	\N	\N
436	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	237	2026-05-06 05:34:56.562584+01	\N	\N
437	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	73	2026-04-27 14:49:29.51018+01	\N	\N
438	2	2	GET	/api/v1/ds_2_products_seed?status=paid	404	66	2026-04-23 18:26:12.447904+01	\N	\N
439	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	83	2026-05-04 13:10:46.554265+01	\N	\N
440	2	2	GET	/api/v1/ds_2_products_seed	200	276	2026-05-10 05:13:33.365702+01	\N	\N
441	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	404	30	2026-05-03 08:31:21.396838+01	\N	\N
442	2	2	GET	/api/v1/ds_2_products_seed/1	200	172	2026-04-19 12:48:16.940349+01	\N	\N
443	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	93	2026-05-04 15:20:12.212949+01	\N	\N
444	2	2	GET	/api/v1/ds_2_products_seed	200	43	2026-05-09 11:41:23.363989+01	\N	\N
445	2	2	GET	/api/v1/ds_2_products_seed/1	200	216	2026-04-20 20:06:10.285639+01	\N	\N
446	2	2	GET	/api/v1/ds_2_products_seed/1	200	84	2026-04-13 20:56:46.419271+01	\N	\N
447	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	83	2026-04-14 17:58:17.30534+01	\N	\N
448	2	2	GET	/api/v1/ds_2_products_seed/schema	200	171	2026-04-25 12:30:46.684892+01	\N	\N
449	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	65	2026-04-18 05:32:07.1894+01	\N	\N
450	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	208	2026-04-22 22:28:09.961083+01	\N	\N
451	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	148	2026-05-03 13:47:37.602125+01	\N	\N
452	2	2	GET	/api/v1/ds_2_products_seed/schema	200	75	2026-05-13 01:31:31.12439+01	\N	\N
453	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	133	2026-05-05 08:16:44.766443+01	\N	\N
454	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	72	2026-04-21 00:46:08.900008+01	\N	\N
455	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	119	2026-04-16 19:08:52.190744+01	\N	\N
456	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	158	2026-05-05 17:47:51.539962+01	\N	\N
457	2	2	GET	/api/v1/ds_2_products_seed	200	175	2026-04-17 06:53:54.796785+01	\N	\N
458	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	66	2026-04-23 06:48:10.010187+01	\N	\N
459	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	113	2026-05-03 13:30:29.270208+01	\N	\N
460	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	217	2026-05-02 05:35:57.532191+01	\N	\N
461	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	221	2026-04-20 08:13:30.007324+01	\N	\N
462	2	2	GET	/api/v1/ds_2_products_seed	200	182	2026-04-29 12:17:10.949382+01	\N	\N
463	2	2	GET	/api/v1/ds_2_products_seed/schema	200	9	2026-04-29 14:50:33.968728+01	\N	\N
464	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	226	2026-04-27 05:17:35.35272+01	\N	\N
465	2	2	GET	/api/v1/ds_2_products_seed/schema	200	12	2026-05-05 16:41:46.322904+01	\N	\N
466	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	135	2026-04-26 12:41:43.205885+01	\N	\N
467	2	2	GET	/api/v1/ds_2_products_seed	200	263	2026-05-07 11:54:06.95316+01	\N	\N
468	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	39	2026-05-06 06:57:09.918491+01	\N	\N
469	2	2	GET	/api/v1/ds_2_products_seed/schema	200	180	2026-04-13 21:31:21.65064+01	\N	\N
470	2	2	GET	/api/v1/ds_2_products_seed/schema	200	275	2026-04-18 02:12:09.968397+01	\N	\N
471	2	2	GET	/api/v1/ds_2_products_seed/1	200	114	2026-05-09 01:40:06.033503+01	\N	\N
472	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	43	2026-04-17 10:48:31.52865+01	\N	\N
473	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	152	2026-04-16 06:09:42.592461+01	\N	\N
474	2	2	GET	/api/v1/ds_2_products_seed/schema	200	162	2026-04-29 12:54:15.858584+01	\N	\N
475	2	2	GET	/api/v1/ds_2_products_seed/schema	200	36	2026-04-23 09:52:08.811393+01	\N	\N
476	2	2	GET	/api/v1/ds_2_products_seed/1	200	175	2026-05-10 20:28:03.33766+01	\N	\N
477	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	22	2026-04-17 17:43:38.598205+01	\N	\N
478	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	219	2026-04-18 06:16:36.402872+01	\N	\N
479	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	115	2026-04-15 09:40:12.869277+01	\N	\N
480	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	32	2026-04-19 18:19:10.221388+01	\N	\N
481	2	2	GET	/api/v1/ds_2_products_seed	200	33	2026-04-28 14:38:16.402632+01	\N	\N
482	2	2	GET	/api/v1/ds_2_products_seed/1	200	93	2026-05-04 12:46:46.768399+01	\N	\N
483	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	178	2026-04-14 23:36:29.360829+01	\N	\N
484	2	2	GET	/api/v1/ds_2_products_seed/1	200	58	2026-04-16 14:01:40.696482+01	\N	\N
485	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	262	2026-05-03 22:04:18.035582+01	\N	\N
486	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	65	2026-04-30 12:32:17.147315+01	\N	\N
487	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	148	2026-04-14 13:03:27.94441+01	\N	\N
488	2	2	GET	/api/v1/ds_2_products_seed/schema	200	191	2026-05-11 13:43:49.762936+01	\N	\N
489	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	69	2026-04-15 12:51:11.248704+01	\N	\N
490	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	202	2026-04-18 03:00:49.353695+01	\N	\N
491	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	153	2026-04-17 03:17:44.586032+01	\N	\N
492	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	79	2026-05-12 18:16:07.241729+01	\N	\N
493	2	2	GET	/api/v1/ds_2_products_seed/schema	200	255	2026-04-27 20:05:33.315291+01	\N	\N
494	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	172	2026-05-12 18:49:06.48182+01	\N	\N
495	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	214	2026-04-24 13:33:11.386497+01	\N	\N
496	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	49	2026-05-13 07:58:14.754865+01	\N	\N
497	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	48	2026-05-11 18:13:45.916024+01	\N	\N
498	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	233	2026-05-12 11:55:35.530248+01	\N	\N
499	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	120	2026-05-06 08:37:30.15184+01	\N	\N
500	2	2	GET	/api/v1/ds_2_products_seed/schema	200	61	2026-04-23 19:43:22.723531+01	\N	\N
501	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	31	2026-04-19 20:57:55.685874+01	\N	\N
502	2	2	GET	/api/v1/ds_2_products_seed/schema	200	228	2026-05-05 07:53:02.371273+01	\N	\N
503	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	44	2026-04-15 14:24:00.634822+01	\N	\N
504	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	266	2026-04-20 00:04:07.225862+01	\N	\N
505	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	14	2026-04-29 15:14:11.205173+01	\N	\N
506	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	19	2026-05-07 08:20:51.139219+01	\N	\N
507	2	2	GET	/api/v1/ds_2_products_seed/1	200	134	2026-04-25 17:56:42.43777+01	\N	\N
508	2	2	GET	/api/v1/ds_2_products_seed/1	200	123	2026-04-18 17:35:49.095914+01	\N	\N
509	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	171	2026-04-21 15:42:05.228429+01	\N	\N
510	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	189	2026-05-09 23:40:59.542676+01	\N	\N
511	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	172	2026-04-19 19:34:16.750347+01	\N	\N
512	2	2	GET	/api/v1/ds_2_products_seed/schema	200	214	2026-04-25 15:03:46.757011+01	\N	\N
513	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	62	2026-05-04 08:32:35.346508+01	\N	\N
514	2	2	GET	/api/v1/ds_2_products_seed/1	200	261	2026-04-22 17:19:00.265632+01	\N	\N
515	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	165	2026-05-04 10:17:13.006965+01	\N	\N
516	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	274	2026-05-12 13:17:53.372783+01	\N	\N
517	2	2	GET	/api/v1/ds_2_products_seed/1	200	111	2026-05-06 02:25:49.851932+01	\N	\N
518	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	273	2026-05-12 04:22:01.660535+01	\N	\N
519	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	219	2026-04-20 22:51:52.24157+01	\N	\N
520	2	2	GET	/api/v1/ds_2_products_seed/1	200	207	2026-04-24 19:03:09.143304+01	\N	\N
521	2	2	GET	/api/v1/ds_2_products_seed/schema	200	230	2026-04-14 17:03:20.990576+01	\N	\N
522	2	2	GET	/api/v1/ds_2_products_seed/1	200	212	2026-05-01 04:01:18.579408+01	\N	\N
523	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	110	2026-04-17 07:00:42.840041+01	\N	\N
524	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	258	2026-05-13 08:43:36.949744+01	\N	\N
525	2	2	GET	/api/v1/ds_2_products_seed/schema	200	116	2026-04-23 14:06:10.723273+01	\N	\N
526	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	86	2026-04-14 21:46:12.890351+01	\N	\N
527	2	2	GET	/api/v1/ds_2_products_seed/schema	200	138	2026-05-02 22:24:16.37937+01	\N	\N
528	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	136	2026-04-28 23:02:52.504423+01	\N	\N
529	2	2	GET	/api/v1/ds_2_products_seed/1	200	48	2026-04-14 23:09:24.51992+01	\N	\N
530	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	85	2026-04-27 23:30:57.82275+01	\N	\N
531	2	2	GET	/api/v1/ds_2_products_seed/schema	200	216	2026-04-18 22:51:22.741709+01	\N	\N
532	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	219	2026-05-08 19:34:58.538055+01	\N	\N
533	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	173	2026-04-28 11:06:50.142794+01	\N	\N
534	2	2	GET	/api/v1/ds_2_products_seed/schema	200	54	2026-05-04 10:59:17.204147+01	\N	\N
535	2	2	GET	/api/v1/ds_2_products_seed/schema	200	62	2026-04-19 01:34:50.076818+01	\N	\N
536	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	93	2026-04-18 09:02:43.382809+01	\N	\N
537	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	226	2026-04-22 18:51:07.623943+01	\N	\N
538	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	106	2026-04-22 23:01:23.924507+01	\N	\N
539	2	2	GET	/api/v1/ds_2_products_seed?page=2	200	156	2026-04-24 11:56:13.315685+01	\N	\N
540	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	404	232	2026-05-09 20:53:04.402419+01	\N	\N
541	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	167	2026-04-24 23:13:23.373564+01	\N	\N
542	2	2	GET	/api/v1/ds_2_products_seed/1	200	98	2026-04-20 15:17:05.751459+01	\N	\N
543	2	2	GET	/api/v1/ds_2_products_seed	200	118	2026-05-12 19:47:39.100412+01	\N	\N
544	2	2	GET	/api/v1/ds_2_products_seed?status=paid	200	142	2026-04-16 04:13:15.518449+01	\N	\N
545	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	53	2026-05-04 05:25:38.568233+01	\N	\N
546	2	2	GET	/api/v1/ds_2_products_seed?region=Europe	200	233	2026-05-12 12:08:48.926299+01	\N	\N
547	2	2	GET	/api/v1/ds_2_products_seed/1	200	71	2026-04-16 14:37:28.937977+01	\N	\N
548	2	2	GET	/api/v1/ds_2_products_seed/1	200	150	2026-05-06 13:45:33.066211+01	\N	\N
549	2	2	GET	/api/v1/ds_2_products_seed	200	246	2026-05-04 21:19:42.456546+01	\N	\N
550	2	2	GET	/api/v1/ds_2_products_seed/schema	200	68	2026-04-24 07:46:51.414088+01	\N	\N
551	3	3	GET	/api/v1/ds_1_employees_seed?region=Europe	200	86	2026-05-08 04:30:52.715704+01	\N	\N
552	3	3	GET	/api/v1/ds_1_employees_seed/1	200	233	2026-04-27 04:10:25.427806+01	\N	\N
553	3	3	GET	/api/v1/ds_1_employees_seed	200	137	2026-05-02 02:58:16.564271+01	\N	\N
554	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	150	2026-04-24 02:48:12.246714+01	\N	\N
555	3	3	GET	/api/v1/ds_1_employees_seed?status=paid	200	216	2026-04-26 00:25:34.767674+01	\N	\N
556	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	106	2026-04-18 11:44:04.922864+01	\N	\N
557	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	90	2026-04-20 12:17:06.085347+01	\N	\N
558	3	3	GET	/api/v1/ds_1_employees_seed/1	200	164	2026-05-02 10:27:40.422593+01	\N	\N
559	3	3	GET	/api/v1/ds_1_employees_seed?region=Europe	200	94	2026-04-25 07:54:39.362802+01	\N	\N
560	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	29	2026-04-24 03:20:52.048231+01	\N	\N
561	3	3	GET	/api/v1/ds_1_employees_seed?status=paid	200	269	2026-05-01 08:20:05.367962+01	\N	\N
562	3	3	GET	/api/v1/ds_1_employees_seed?page=2	200	39	2026-05-07 06:37:26.173991+01	\N	\N
563	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	213	2026-04-26 14:57:16.838452+01	\N	\N
564	3	3	GET	/api/v1/ds_1_employees_seed	200	228	2026-04-23 23:38:03.250502+01	\N	\N
565	3	3	GET	/api/v1/ds_1_employees_seed?status=paid	200	144	2026-04-28 00:20:43.349552+01	\N	\N
566	3	3	GET	/api/v1/ds_1_employees_seed/1	200	135	2026-04-19 21:29:01.765778+01	\N	\N
567	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	269	2026-05-08 06:11:01.450699+01	\N	\N
568	3	3	GET	/api/v1/ds_1_employees_seed?page=2	200	237	2026-04-16 04:33:46.554393+01	\N	\N
569	3	3	GET	/api/v1/ds_1_employees_seed/1	200	279	2026-04-26 10:39:18.790447+01	\N	\N
570	3	3	GET	/api/v1/ds_1_employees_seed?region=Europe	200	105	2026-04-18 19:29:04.216093+01	\N	\N
571	3	3	GET	/api/v1/ds_1_employees_seed/1	200	58	2026-05-03 16:07:08.591607+01	\N	\N
572	3	3	GET	/api/v1/ds_1_employees_seed?page=2	200	179	2026-05-04 14:50:06.99362+01	\N	\N
573	3	3	GET	/api/v1/ds_1_employees_seed/1	200	100	2026-05-08 22:08:53.997368+01	\N	\N
574	3	3	GET	/api/v1/ds_1_employees_seed?page=2	404	112	2026-04-15 00:09:17.85804+01	\N	\N
575	3	3	GET	/api/v1/ds_1_employees_seed/1	200	129	2026-04-15 02:13:54.115037+01	\N	\N
576	3	3	GET	/api/v1/ds_1_employees_seed/1	200	38	2026-05-03 06:33:13.844008+01	\N	\N
577	3	3	GET	/api/v1/ds_1_employees_seed?region=Europe	200	145	2026-04-25 12:00:09.341545+01	\N	\N
578	3	3	GET	/api/v1/ds_1_employees_seed	200	152	2026-04-30 18:38:16.798562+01	\N	\N
579	3	3	GET	/api/v1/ds_1_employees_seed	200	134	2026-04-28 23:12:41.079381+01	\N	\N
580	3	3	GET	/api/v1/ds_1_employees_seed/1	200	237	2026-05-10 10:17:53.686431+01	\N	\N
581	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	223	2026-05-04 05:51:26.651362+01	\N	\N
582	3	3	GET	/api/v1/ds_1_employees_seed?region=Europe	200	194	2026-05-11 20:20:24.159978+01	\N	\N
583	3	3	GET	/api/v1/ds_1_employees_seed	200	109	2026-04-21 08:38:58.124496+01	\N	\N
584	3	3	GET	/api/v1/ds_1_employees_seed?status=paid	200	95	2026-05-07 22:55:06.010998+01	\N	\N
585	3	3	GET	/api/v1/ds_1_employees_seed/1	200	39	2026-05-11 02:18:35.638116+01	\N	\N
586	3	3	GET	/api/v1/ds_1_employees_seed?page=2	200	144	2026-05-08 10:26:07.103977+01	\N	\N
587	3	3	GET	/api/v1/ds_1_employees_seed	200	219	2026-05-09 14:31:50.800548+01	\N	\N
588	3	3	GET	/api/v1/ds_1_employees_seed	200	87	2026-05-02 10:46:45.267765+01	\N	\N
589	3	3	GET	/api/v1/ds_1_employees_seed?region=Europe	200	276	2026-04-27 21:56:10.43822+01	\N	\N
590	3	3	GET	/api/v1/ds_1_employees_seed?page=2	200	49	2026-04-23 18:10:07.284202+01	\N	\N
591	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	92	2026-05-04 11:45:08.579502+01	\N	\N
592	3	3	GET	/api/v1/ds_1_employees_seed/1	200	239	2026-04-19 09:53:43.210697+01	\N	\N
593	3	3	GET	/api/v1/ds_1_employees_seed?status=paid	200	88	2026-04-27 23:41:41.555082+01	\N	\N
594	3	3	GET	/api/v1/ds_1_employees_seed?page=2	200	155	2026-04-30 07:27:50.491415+01	\N	\N
595	3	3	GET	/api/v1/ds_1_employees_seed?page=2	200	235	2026-05-09 11:19:43.53992+01	\N	\N
596	3	3	GET	/api/v1/ds_1_employees_seed?page=2	200	52	2026-05-09 04:12:28.962977+01	\N	\N
597	3	3	GET	/api/v1/ds_1_employees_seed/1	200	257	2026-05-11 00:15:40.96176+01	\N	\N
598	3	3	GET	/api/v1/ds_1_employees_seed/1	200	9	2026-04-14 19:53:44.560084+01	\N	\N
599	3	3	GET	/api/v1/ds_1_employees_seed	200	178	2026-05-03 16:49:48.686052+01	\N	\N
600	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	158	2026-04-25 01:01:30.931034+01	\N	\N
601	3	3	GET	/api/v1/ds_1_employees_seed/schema	403	14	2026-05-06 02:19:46.594657+01	\N	\N
602	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	144	2026-05-07 12:40:44.784516+01	\N	\N
603	3	3	GET	/api/v1/ds_1_employees_seed/1	200	63	2026-04-15 05:20:05.752461+01	\N	\N
604	3	3	GET	/api/v1/ds_1_employees_seed/1	200	139	2026-04-28 18:42:48.597813+01	\N	\N
605	3	3	GET	/api/v1/ds_1_employees_seed?region=Europe	200	17	2026-05-12 23:49:52.866023+01	\N	\N
606	3	3	GET	/api/v1/ds_1_employees_seed/1	200	24	2026-05-10 13:51:31.733122+01	\N	\N
607	3	3	GET	/api/v1/ds_1_employees_seed?region=Europe	200	133	2026-04-17 03:27:20.78086+01	\N	\N
608	3	3	GET	/api/v1/ds_1_employees_seed/1	200	172	2026-05-08 20:17:58.370016+01	\N	\N
609	3	3	GET	/api/v1/ds_1_employees_seed?region=Europe	200	64	2026-05-09 22:13:29.503165+01	\N	\N
610	3	3	GET	/api/v1/ds_1_employees_seed	200	112	2026-04-29 07:37:39.477101+01	\N	\N
611	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	92	2026-04-22 12:43:18.837362+01	\N	\N
612	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	136	2026-04-29 18:59:10.847979+01	\N	\N
613	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	123	2026-04-13 17:52:03.335917+01	\N	\N
614	3	3	GET	/api/v1/ds_1_employees_seed?status=paid	200	33	2026-05-07 23:28:14.188779+01	\N	\N
615	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	211	2026-04-16 04:20:13.766492+01	\N	\N
616	3	3	GET	/api/v1/ds_1_employees_seed/1	200	119	2026-05-01 18:46:22.021306+01	\N	\N
617	3	3	GET	/api/v1/ds_1_employees_seed?status=paid	200	52	2026-04-26 17:41:56.48439+01	\N	\N
618	3	3	GET	/api/v1/ds_1_employees_seed/1	200	55	2026-05-07 07:24:07.907535+01	\N	\N
619	3	3	GET	/api/v1/ds_1_employees_seed	200	170	2026-04-24 19:50:02.978421+01	\N	\N
620	3	3	GET	/api/v1/ds_1_employees_seed	200	143	2026-05-08 09:16:05.961543+01	\N	\N
621	3	3	GET	/api/v1/ds_1_employees_seed/1	200	63	2026-04-13 16:08:34.549817+01	\N	\N
622	3	3	GET	/api/v1/ds_1_employees_seed/1	200	253	2026-04-30 20:40:25.463907+01	\N	\N
623	3	3	GET	/api/v1/ds_1_employees_seed?status=paid	200	209	2026-04-15 18:21:20.844755+01	\N	\N
624	3	3	GET	/api/v1/ds_1_employees_seed?page=2	200	226	2026-04-29 09:37:31.846525+01	\N	\N
625	3	3	GET	/api/v1/ds_1_employees_seed?page=2	200	136	2026-04-23 22:18:19.012502+01	\N	\N
626	3	3	GET	/api/v1/ds_1_employees_seed/1	200	162	2026-04-28 04:40:56.780245+01	\N	\N
627	3	3	GET	/api/v1/ds_1_employees_seed?page=2	200	279	2026-04-15 00:53:14.304236+01	\N	\N
628	3	3	GET	/api/v1/ds_1_employees_seed?region=Europe	200	55	2026-04-29 23:44:58.617004+01	\N	\N
629	3	3	GET	/api/v1/ds_1_employees_seed?status=paid	200	117	2026-04-19 05:01:04.525502+01	\N	\N
630	3	3	GET	/api/v1/ds_1_employees_seed?page=2	403	199	2026-04-15 07:52:30.321776+01	\N	\N
631	3	3	GET	/api/v1/ds_1_employees_seed	200	34	2026-04-16 18:57:36.341188+01	\N	\N
632	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	19	2026-04-14 05:50:48.604227+01	\N	\N
633	3	3	GET	/api/v1/ds_1_employees_seed?status=paid	200	242	2026-04-15 16:00:21.271635+01	\N	\N
634	3	3	GET	/api/v1/ds_1_employees_seed	200	200	2026-04-24 14:44:17.082425+01	\N	\N
635	3	3	GET	/api/v1/ds_1_employees_seed	200	54	2026-04-21 12:27:40.315328+01	\N	\N
636	3	3	GET	/api/v1/ds_1_employees_seed	200	32	2026-05-05 05:09:02.33292+01	\N	\N
637	3	3	GET	/api/v1/ds_1_employees_seed?status=paid	200	202	2026-04-30 10:13:40.053171+01	\N	\N
638	3	3	GET	/api/v1/ds_1_employees_seed?status=paid	200	278	2026-05-05 22:13:21.673749+01	\N	\N
639	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	49	2026-04-23 07:11:57.38048+01	\N	\N
640	3	3	GET	/api/v1/ds_1_employees_seed?page=2	200	48	2026-05-10 08:32:59.034649+01	\N	\N
641	3	3	GET	/api/v1/ds_1_employees_seed	200	265	2026-04-26 20:49:08.112153+01	\N	\N
642	3	3	GET	/api/v1/ds_1_employees_seed?page=2	200	26	2026-05-05 01:08:12.581657+01	\N	\N
643	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	33	2026-05-01 02:58:54.021145+01	\N	\N
644	3	3	GET	/api/v1/ds_1_employees_seed/1	200	85	2026-04-23 08:55:39.001282+01	\N	\N
645	3	3	GET	/api/v1/ds_1_employees_seed/schema	200	186	2026-04-22 08:28:15.390669+01	\N	\N
646	4	4	GET	/api/v1/ds_2_sales_seed	200	214	2026-05-03 18:49:09.5743+01	\N	\N
647	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	403	38	2026-05-01 18:39:10.8695+01	\N	\N
648	4	4	GET	/api/v1/ds_2_sales_seed/1	200	84	2026-05-09 23:14:04.944743+01	\N	\N
649	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	40	2026-04-16 06:21:22.377719+01	\N	\N
650	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	244	2026-05-09 20:00:14.382227+01	\N	\N
651	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	257	2026-04-23 09:51:18.348026+01	\N	\N
652	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	167	2026-05-04 03:06:03.108819+01	\N	\N
653	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	107	2026-04-28 10:42:23.878532+01	\N	\N
654	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	93	2026-04-30 21:47:42.068515+01	\N	\N
655	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	151	2026-04-22 21:14:35.815387+01	\N	\N
656	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	156	2026-04-26 19:06:43.128873+01	\N	\N
657	4	4	GET	/api/v1/ds_2_sales_seed?page=2	404	96	2026-04-15 13:59:10.604714+01	\N	\N
658	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	204	2026-04-30 05:35:39.31654+01	\N	\N
659	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	59	2026-04-16 15:27:07.312928+01	\N	\N
660	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	163	2026-05-01 09:47:09.237571+01	\N	\N
661	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	167	2026-04-21 09:53:16.703006+01	\N	\N
662	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	29	2026-04-15 01:26:46.368551+01	\N	\N
663	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	197	2026-05-04 04:56:41.910053+01	\N	\N
664	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	157	2026-04-21 23:36:43.234616+01	\N	\N
665	4	4	GET	/api/v1/ds_2_sales_seed/1	200	127	2026-04-26 21:46:18.343508+01	\N	\N
666	4	4	GET	/api/v1/ds_2_sales_seed/1	200	47	2026-04-19 00:18:46.35579+01	\N	\N
667	4	4	GET	/api/v1/ds_2_sales_seed/1	200	8	2026-05-04 20:25:45.649854+01	\N	\N
668	4	4	GET	/api/v1/ds_2_sales_seed	200	91	2026-04-24 03:54:13.94778+01	\N	\N
669	4	4	GET	/api/v1/ds_2_sales_seed	200	165	2026-05-10 03:06:13.788365+01	\N	\N
670	4	4	GET	/api/v1/ds_2_sales_seed	404	259	2026-05-01 01:58:57.756778+01	\N	\N
671	4	4	GET	/api/v1/ds_2_sales_seed?page=2	404	93	2026-04-27 19:58:44.495624+01	\N	\N
672	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	128	2026-04-30 23:38:07.553253+01	\N	\N
673	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	33	2026-05-03 17:49:02.091237+01	\N	\N
674	4	4	GET	/api/v1/ds_2_sales_seed/1	200	173	2026-04-21 08:49:45.419987+01	\N	\N
675	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	43	2026-04-30 11:22:14.872014+01	\N	\N
676	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	47	2026-04-13 16:59:12.950299+01	\N	\N
677	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	149	2026-04-28 06:07:25.453705+01	\N	\N
678	4	4	GET	/api/v1/ds_2_sales_seed/schema	404	276	2026-04-16 06:35:09.957249+01	\N	\N
679	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	159	2026-04-18 13:16:49.214897+01	\N	\N
680	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	156	2026-05-03 23:43:13.067529+01	\N	\N
681	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	155	2026-05-09 14:24:39.500238+01	\N	\N
682	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	34	2026-05-06 15:56:54.687796+01	\N	\N
683	4	4	GET	/api/v1/ds_2_sales_seed/1	200	238	2026-04-27 07:11:34.369461+01	\N	\N
684	4	4	GET	/api/v1/ds_2_sales_seed/1	200	66	2026-05-09 11:14:14.90385+01	\N	\N
685	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	192	2026-04-24 16:43:16.561233+01	\N	\N
686	4	4	GET	/api/v1/ds_2_sales_seed/schema	403	57	2026-04-22 15:58:50.220485+01	\N	\N
687	4	4	GET	/api/v1/ds_2_sales_seed	200	117	2026-05-03 07:33:20.33417+01	\N	\N
688	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	157	2026-05-08 12:36:44.148755+01	\N	\N
689	4	4	GET	/api/v1/ds_2_sales_seed/1	200	201	2026-05-05 17:54:02.523565+01	\N	\N
690	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	39	2026-04-29 05:19:51.665813+01	\N	\N
691	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	128	2026-05-01 13:36:47.945346+01	\N	\N
692	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	152	2026-04-27 12:19:04.023422+01	\N	\N
693	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	227	2026-04-26 09:16:29.223386+01	\N	\N
694	4	4	GET	/api/v1/ds_2_sales_seed	200	117	2026-04-29 22:24:09.153354+01	\N	\N
695	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	133	2026-04-14 11:43:22.608242+01	\N	\N
696	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	184	2026-04-17 18:04:54.09389+01	\N	\N
697	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	274	2026-05-07 20:21:05.382179+01	\N	\N
698	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	264	2026-05-12 10:29:22.931095+01	\N	\N
699	4	4	GET	/api/v1/ds_2_sales_seed/1	200	93	2026-05-08 08:47:20.064785+01	\N	\N
700	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	77	2026-04-26 12:31:10.660928+01	\N	\N
701	4	4	GET	/api/v1/ds_2_sales_seed/1	200	16	2026-04-20 20:22:41.106412+01	\N	\N
702	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	251	2026-05-10 17:47:27.225711+01	\N	\N
703	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	129	2026-04-30 16:48:08.776742+01	\N	\N
704	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	197	2026-04-19 22:37:05.654131+01	\N	\N
705	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	115	2026-04-19 13:19:42.245626+01	\N	\N
706	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	187	2026-05-04 13:58:35.279009+01	\N	\N
707	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	91	2026-04-28 11:27:38.612621+01	\N	\N
708	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	13	2026-04-22 16:01:22.130662+01	\N	\N
709	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	173	2026-05-02 13:50:07.818121+01	\N	\N
710	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	233	2026-05-08 16:22:39.779038+01	\N	\N
711	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	155	2026-04-26 12:02:11.206454+01	\N	\N
712	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	250	2026-05-05 08:46:26.077583+01	\N	\N
713	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	167	2026-04-16 04:59:53.795791+01	\N	\N
714	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	36	2026-05-04 11:26:25.496784+01	\N	\N
715	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	176	2026-04-28 02:55:06.728444+01	\N	\N
716	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	183	2026-05-05 00:47:44.328648+01	\N	\N
717	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	95	2026-05-10 13:52:57.530729+01	\N	\N
718	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	249	2026-04-21 07:04:30.251854+01	\N	\N
719	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	85	2026-04-19 02:04:12.426319+01	\N	\N
720	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	62	2026-04-20 00:11:33.232326+01	\N	\N
721	4	4	GET	/api/v1/ds_2_sales_seed/1	200	218	2026-04-26 15:39:11.95779+01	\N	\N
722	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	273	2026-04-26 10:53:36.07977+01	\N	\N
723	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	87	2026-05-03 16:07:48.590851+01	\N	\N
724	4	4	GET	/api/v1/ds_2_sales_seed/1	200	100	2026-04-24 17:16:33.275018+01	\N	\N
725	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	194	2026-05-04 13:05:34.935435+01	\N	\N
726	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	157	2026-04-29 17:38:48.478734+01	\N	\N
727	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	10	2026-04-23 10:41:29.978444+01	\N	\N
728	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	244	2026-04-17 19:49:16.155854+01	\N	\N
729	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	38	2026-04-14 21:33:19.193554+01	\N	\N
730	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	404	149	2026-05-06 09:45:39.681283+01	\N	\N
731	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	255	2026-05-01 01:58:03.346024+01	\N	\N
732	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	240	2026-05-13 05:26:03.291832+01	\N	\N
733	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	168	2026-04-24 13:17:13.448277+01	\N	\N
734	4	4	GET	/api/v1/ds_2_sales_seed/1	200	245	2026-04-15 11:19:25.360843+01	\N	\N
735	4	4	GET	/api/v1/ds_2_sales_seed/1	200	211	2026-04-14 14:22:27.650326+01	\N	\N
736	4	4	GET	/api/v1/ds_2_sales_seed/schema	404	34	2026-05-10 06:39:48.690403+01	\N	\N
737	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	77	2026-05-05 19:44:52.234614+01	\N	\N
738	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	25	2026-04-22 23:17:47.458453+01	\N	\N
739	4	4	GET	/api/v1/ds_2_sales_seed/1	200	157	2026-05-01 20:21:19.325496+01	\N	\N
740	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	108	2026-05-05 03:26:31.803011+01	\N	\N
741	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	246	2026-05-10 23:02:46.184746+01	\N	\N
742	4	4	GET	/api/v1/ds_2_sales_seed/1	200	22	2026-04-19 22:24:54.057612+01	\N	\N
743	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	138	2026-04-26 20:02:27.636397+01	\N	\N
744	4	4	GET	/api/v1/ds_2_sales_seed/1	200	245	2026-04-30 00:16:49.041435+01	\N	\N
745	4	4	GET	/api/v1/ds_2_sales_seed	200	179	2026-04-29 20:16:53.755957+01	\N	\N
746	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	197	2026-04-26 11:16:41.583992+01	\N	\N
747	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	126	2026-05-07 10:07:32.132606+01	\N	\N
748	4	4	GET	/api/v1/ds_2_sales_seed/1	200	164	2026-05-09 00:58:58.807125+01	\N	\N
749	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	403	66	2026-04-29 21:15:53.304456+01	\N	\N
750	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	269	2026-04-19 15:29:14.202374+01	\N	\N
751	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	171	2026-04-26 10:05:08.988854+01	\N	\N
752	4	4	GET	/api/v1/ds_2_sales_seed/1	200	196	2026-05-06 06:53:02.593388+01	\N	\N
753	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	129	2026-04-15 08:33:00.528701+01	\N	\N
754	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	168	2026-04-21 04:43:54.402929+01	\N	\N
755	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	112	2026-04-13 19:31:39.847751+01	\N	\N
756	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	187	2026-05-10 16:03:56.592173+01	\N	\N
757	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	78	2026-05-11 14:47:32.933281+01	\N	\N
758	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	115	2026-05-03 21:28:27.149092+01	\N	\N
759	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	14	2026-04-22 17:24:47.82859+01	\N	\N
760	4	4	GET	/api/v1/ds_2_sales_seed/1	200	180	2026-04-16 20:03:13.440257+01	\N	\N
761	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	61	2026-04-27 05:07:17.082361+01	\N	\N
762	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	276	2026-05-05 01:14:33.310691+01	\N	\N
763	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	22	2026-04-26 21:46:11.753959+01	\N	\N
764	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	191	2026-05-12 08:34:08.994338+01	\N	\N
765	4	4	GET	/api/v1/ds_2_sales_seed/1	200	150	2026-05-10 16:46:36.015057+01	\N	\N
766	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	214	2026-05-04 23:31:37.677431+01	\N	\N
767	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	22	2026-05-04 21:04:10.678453+01	\N	\N
768	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	224	2026-04-30 02:10:59.001374+01	\N	\N
769	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	224	2026-05-05 09:38:40.088057+01	\N	\N
770	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	167	2026-04-26 05:00:54.605243+01	\N	\N
771	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	69	2026-05-04 18:42:02.748158+01	\N	\N
772	4	4	GET	/api/v1/ds_2_sales_seed	200	139	2026-04-30 09:48:15.957749+01	\N	\N
773	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	404	52	2026-05-03 02:12:09.019149+01	\N	\N
774	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	26	2026-05-10 16:58:20.907909+01	\N	\N
775	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	132	2026-05-07 20:17:27.459871+01	\N	\N
776	4	4	GET	/api/v1/ds_2_sales_seed/1	200	11	2026-04-24 15:33:44.798681+01	\N	\N
777	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	188	2026-04-28 03:07:21.618398+01	\N	\N
778	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	261	2026-04-18 19:24:18.502435+01	\N	\N
779	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	245	2026-04-30 18:12:27.109644+01	\N	\N
780	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	217	2026-04-28 01:55:08.794248+01	\N	\N
781	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	63	2026-04-14 09:43:45.540654+01	\N	\N
782	4	4	GET	/api/v1/ds_2_sales_seed/1	200	53	2026-04-21 14:01:24.036446+01	\N	\N
783	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	193	2026-04-14 08:03:53.983916+01	\N	\N
784	4	4	GET	/api/v1/ds_2_sales_seed/1	200	272	2026-05-11 18:04:32.216356+01	\N	\N
785	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	40	2026-05-09 15:25:01.085428+01	\N	\N
786	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	41	2026-05-04 05:20:24.219414+01	\N	\N
787	4	4	GET	/api/v1/ds_2_sales_seed	200	190	2026-05-03 13:50:35.205877+01	\N	\N
788	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	41	2026-04-30 13:22:24.609372+01	\N	\N
789	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	404	203	2026-04-19 04:19:03.359523+01	\N	\N
790	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	122	2026-05-07 01:29:57.158829+01	\N	\N
791	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	190	2026-04-15 22:17:43.668406+01	\N	\N
792	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	69	2026-04-20 13:12:15.74322+01	\N	\N
793	4	4	GET	/api/v1/ds_2_sales_seed	200	23	2026-05-13 00:49:11.072985+01	\N	\N
794	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	207	2026-05-05 20:12:53.512535+01	\N	\N
795	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	86	2026-05-04 07:54:24.805402+01	\N	\N
796	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	189	2026-05-03 10:07:20.89349+01	\N	\N
797	4	4	GET	/api/v1/ds_2_sales_seed/1	200	213	2026-05-04 03:20:26.263668+01	\N	\N
798	4	4	GET	/api/v1/ds_2_sales_seed	200	99	2026-05-04 15:01:38.628791+01	\N	\N
799	4	4	GET	/api/v1/ds_2_sales_seed	200	158	2026-04-17 04:50:28.596499+01	\N	\N
800	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	167	2026-04-26 23:01:17.295996+01	\N	\N
801	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	93	2026-05-12 04:39:50.136166+01	\N	\N
802	4	4	GET	/api/v1/ds_2_sales_seed/1	200	156	2026-04-19 06:17:35.108994+01	\N	\N
803	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	64	2026-04-18 21:11:06.498856+01	\N	\N
804	4	4	GET	/api/v1/ds_2_sales_seed/1	200	239	2026-05-02 20:48:55.218483+01	\N	\N
805	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	52	2026-04-19 19:58:06.488001+01	\N	\N
806	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	202	2026-05-09 01:32:05.201415+01	\N	\N
807	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	11	2026-05-08 06:19:16.704975+01	\N	\N
808	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	252	2026-04-22 00:58:23.793823+01	\N	\N
809	4	4	GET	/api/v1/ds_2_sales_seed/1	200	210	2026-04-15 15:50:50.004528+01	\N	\N
810	4	4	GET	/api/v1/ds_2_sales_seed	200	186	2026-05-02 08:27:55.5912+01	\N	\N
811	4	4	GET	/api/v1/ds_2_sales_seed/1	200	174	2026-04-26 00:00:58.179964+01	\N	\N
812	4	4	GET	/api/v1/ds_2_sales_seed/1	200	101	2026-05-06 17:07:06.89212+01	\N	\N
813	4	4	GET	/api/v1/ds_2_sales_seed	200	20	2026-05-11 23:05:00.71727+01	\N	\N
814	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	21	2026-05-03 10:36:24.532801+01	\N	\N
815	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	403	9	2026-05-01 04:47:31.866778+01	\N	\N
816	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	112	2026-04-28 14:37:18.784311+01	\N	\N
817	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	199	2026-05-04 23:36:42.871816+01	\N	\N
818	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	49	2026-04-14 20:31:24.718169+01	\N	\N
819	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	170	2026-04-20 08:22:23.569016+01	\N	\N
820	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	52	2026-04-25 22:19:12.536995+01	\N	\N
821	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	151	2026-05-04 14:21:50.284086+01	\N	\N
822	4	4	GET	/api/v1/ds_2_sales_seed	200	40	2026-05-06 06:10:54.164069+01	\N	\N
823	4	4	GET	/api/v1/ds_2_sales_seed	200	49	2026-05-05 01:33:47.264819+01	\N	\N
824	4	4	GET	/api/v1/ds_2_sales_seed	200	22	2026-05-12 22:16:49.934455+01	\N	\N
825	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	94	2026-05-13 00:00:40.059196+01	\N	\N
826	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	58	2026-05-08 10:00:51.874001+01	\N	\N
827	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	162	2026-04-25 19:15:43.001449+01	\N	\N
828	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	142	2026-05-10 01:48:17.070628+01	\N	\N
829	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	94	2026-05-01 22:33:56.127604+01	\N	\N
830	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	66	2026-04-26 04:48:17.919478+01	\N	\N
831	4	4	GET	/api/v1/ds_2_sales_seed	200	222	2026-04-16 01:08:10.376923+01	\N	\N
832	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	11	2026-05-09 04:15:44.947074+01	\N	\N
833	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	38	2026-04-25 15:56:55.383902+01	\N	\N
834	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	404	236	2026-05-07 15:09:11.577508+01	\N	\N
835	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	79	2026-04-19 01:26:18.65801+01	\N	\N
836	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	214	2026-05-03 23:06:24.353678+01	\N	\N
837	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	269	2026-05-01 20:29:29.524182+01	\N	\N
838	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	184	2026-04-28 07:23:05.969945+01	\N	\N
839	4	4	GET	/api/v1/ds_2_sales_seed	200	191	2026-05-12 17:43:26.361218+01	\N	\N
840	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	24	2026-04-17 16:54:06.2859+01	\N	\N
841	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	275	2026-05-11 06:56:41.202024+01	\N	\N
842	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	247	2026-04-22 21:13:14.814899+01	\N	\N
843	4	4	GET	/api/v1/ds_2_sales_seed	200	53	2026-04-28 15:54:07.534387+01	\N	\N
844	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	54	2026-05-04 06:08:13.929341+01	\N	\N
845	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	117	2026-05-12 19:38:35.771564+01	\N	\N
846	4	4	GET	/api/v1/ds_2_sales_seed	200	93	2026-05-01 19:08:53.847215+01	\N	\N
847	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	176	2026-05-10 16:41:23.786392+01	\N	\N
848	4	4	GET	/api/v1/ds_2_sales_seed	200	227	2026-05-12 00:47:34.43428+01	\N	\N
849	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	230	2026-04-30 19:42:19.903774+01	\N	\N
850	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	61	2026-04-14 05:40:00.335+01	\N	\N
851	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	272	2026-04-16 19:26:05.955787+01	\N	\N
852	4	4	GET	/api/v1/ds_2_sales_seed/1	200	78	2026-05-06 23:06:59.96633+01	\N	\N
853	4	4	GET	/api/v1/ds_2_sales_seed/1	404	184	2026-05-05 06:14:50.08924+01	\N	\N
854	4	4	GET	/api/v1/ds_2_sales_seed/1	200	188	2026-05-04 20:13:08.069118+01	\N	\N
855	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	210	2026-04-29 14:33:47.848852+01	\N	\N
856	4	4	GET	/api/v1/ds_2_sales_seed/1	200	147	2026-05-13 07:04:59.441322+01	\N	\N
857	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	153	2026-04-25 18:17:05.59619+01	\N	\N
858	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	78	2026-04-26 12:13:06.755532+01	\N	\N
859	4	4	GET	/api/v1/ds_2_sales_seed	200	107	2026-04-17 18:29:24.432645+01	\N	\N
860	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	141	2026-04-25 19:57:51.898824+01	\N	\N
861	4	4	GET	/api/v1/ds_2_sales_seed	404	185	2026-04-18 16:08:47.211747+01	\N	\N
862	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	182	2026-05-12 11:48:22.584216+01	\N	\N
863	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	101	2026-04-21 15:03:01.984797+01	\N	\N
864	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	163	2026-05-07 00:58:55.667776+01	\N	\N
865	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	45	2026-04-14 14:50:38.229741+01	\N	\N
866	4	4	GET	/api/v1/ds_2_sales_seed/1	200	175	2026-04-23 20:49:03.012895+01	\N	\N
867	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	129	2026-04-18 07:43:03.072045+01	\N	\N
868	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	254	2026-04-15 17:45:22.391334+01	\N	\N
869	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	245	2026-05-11 18:14:49.843167+01	\N	\N
870	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	184	2026-05-12 11:35:14.117236+01	\N	\N
871	4	4	GET	/api/v1/ds_2_sales_seed	200	219	2026-05-09 22:39:36.127752+01	\N	\N
872	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	57	2026-04-19 20:57:12.579423+01	\N	\N
873	4	4	GET	/api/v1/ds_2_sales_seed/1	200	174	2026-04-24 03:59:53.434914+01	\N	\N
874	4	4	GET	/api/v1/ds_2_sales_seed/1	200	51	2026-05-04 14:46:15.313145+01	\N	\N
875	4	4	GET	/api/v1/ds_2_sales_seed	200	67	2026-05-03 05:29:10.215173+01	\N	\N
876	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	196	2026-04-29 03:52:43.470994+01	\N	\N
877	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	60	2026-05-05 02:16:46.319559+01	\N	\N
878	4	4	GET	/api/v1/ds_2_sales_seed/1	200	202	2026-04-20 23:59:12.643364+01	\N	\N
879	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	51	2026-05-03 06:36:21.354334+01	\N	\N
880	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	149	2026-04-23 14:30:54.914047+01	\N	\N
881	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	128	2026-05-07 01:58:22.898269+01	\N	\N
882	4	4	GET	/api/v1/ds_2_sales_seed/schema	403	156	2026-05-09 13:24:10.380503+01	\N	\N
883	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	102	2026-05-08 17:17:05.944298+01	\N	\N
884	4	4	GET	/api/v1/ds_2_sales_seed/1	200	203	2026-04-28 19:13:59.16437+01	\N	\N
885	4	4	GET	/api/v1/ds_2_sales_seed/1	200	153	2026-05-06 17:16:53.339324+01	\N	\N
886	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	403	168	2026-04-26 09:09:36.932621+01	\N	\N
887	4	4	GET	/api/v1/ds_2_sales_seed/1	200	239	2026-05-05 23:19:21.774714+01	\N	\N
888	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	223	2026-04-15 16:03:54.876475+01	\N	\N
889	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	105	2026-04-21 03:01:32.479334+01	\N	\N
890	4	4	GET	/api/v1/ds_2_sales_seed/1	200	145	2026-05-08 20:26:50.840418+01	\N	\N
891	4	4	GET	/api/v1/ds_2_sales_seed/1	200	224	2026-04-26 07:28:57.360168+01	\N	\N
892	4	4	GET	/api/v1/ds_2_sales_seed/1	200	26	2026-04-19 15:54:19.142872+01	\N	\N
893	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	91	2026-05-01 09:14:31.699498+01	\N	\N
894	4	4	GET	/api/v1/ds_2_sales_seed	200	165	2026-04-16 22:40:24.60299+01	\N	\N
895	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	145	2026-05-01 13:56:55.098764+01	\N	\N
896	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	46	2026-05-05 17:12:12.161019+01	\N	\N
897	4	4	GET	/api/v1/ds_2_sales_seed?page=2	403	17	2026-04-29 19:31:16.828107+01	\N	\N
898	4	4	GET	/api/v1/ds_2_sales_seed/1	200	229	2026-05-01 19:16:50.129219+01	\N	\N
899	4	4	GET	/api/v1/ds_2_sales_seed	200	126	2026-04-15 14:35:36.590656+01	\N	\N
900	4	4	GET	/api/v1/ds_2_sales_seed	200	271	2026-04-23 07:09:18.311232+01	\N	\N
901	4	4	GET	/api/v1/ds_2_sales_seed	200	102	2026-04-24 09:47:23.476955+01	\N	\N
902	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	47	2026-04-15 21:42:08.53862+01	\N	\N
903	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	203	2026-05-03 10:59:46.133509+01	\N	\N
904	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	235	2026-05-07 23:30:46.348655+01	\N	\N
905	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	266	2026-05-10 05:00:58.942487+01	\N	\N
906	4	4	GET	/api/v1/ds_2_sales_seed/1	200	184	2026-05-09 00:35:54.508334+01	\N	\N
907	4	4	GET	/api/v1/ds_2_sales_seed/1	200	176	2026-04-28 03:45:16.473653+01	\N	\N
908	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	150	2026-04-16 22:15:44.508775+01	\N	\N
909	4	4	GET	/api/v1/ds_2_sales_seed/schema	403	97	2026-04-16 11:39:08.633023+01	\N	\N
910	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	209	2026-04-29 10:08:32.396044+01	\N	\N
911	4	4	GET	/api/v1/ds_2_sales_seed/1	200	15	2026-04-26 23:46:52.832346+01	\N	\N
912	4	4	GET	/api/v1/ds_2_sales_seed/1	403	208	2026-05-10 10:23:38.099139+01	\N	\N
913	4	4	GET	/api/v1/ds_2_sales_seed/1	200	229	2026-04-16 19:31:29.549859+01	\N	\N
914	4	4	GET	/api/v1/ds_2_sales_seed/schema	404	149	2026-04-14 20:08:06.307613+01	\N	\N
915	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	89	2026-04-22 19:13:55.072587+01	\N	\N
916	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	87	2026-04-26 22:53:22.079636+01	\N	\N
917	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	168	2026-05-10 23:27:08.698706+01	\N	\N
918	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	160	2026-04-21 01:29:25.502769+01	\N	\N
919	4	4	GET	/api/v1/ds_2_sales_seed	200	210	2026-04-24 14:13:18.373808+01	\N	\N
920	4	4	GET	/api/v1/ds_2_sales_seed/1	200	47	2026-05-05 18:50:27.696943+01	\N	\N
921	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	114	2026-04-18 20:01:35.082807+01	\N	\N
922	4	4	GET	/api/v1/ds_2_sales_seed	200	75	2026-04-14 01:33:02.598637+01	\N	\N
923	4	4	GET	/api/v1/ds_2_sales_seed	200	192	2026-04-19 00:38:27.155122+01	\N	\N
924	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	74	2026-04-27 07:13:32.512293+01	\N	\N
925	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	221	2026-04-17 02:18:19.980813+01	\N	\N
926	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	33	2026-04-23 15:59:45.511312+01	\N	\N
927	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	113	2026-05-09 18:28:46.931097+01	\N	\N
928	4	4	GET	/api/v1/ds_2_sales_seed/1	200	8	2026-04-17 05:55:12.733414+01	\N	\N
929	4	4	GET	/api/v1/ds_2_sales_seed/1	200	166	2026-04-22 11:54:48.833767+01	\N	\N
930	4	4	GET	/api/v1/ds_2_sales_seed	200	50	2026-04-21 20:52:22.85354+01	\N	\N
931	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	127	2026-05-01 18:39:42.009314+01	\N	\N
932	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	216	2026-05-07 07:11:51.81801+01	\N	\N
933	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	404	48	2026-04-19 22:13:58.475397+01	\N	\N
934	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	98	2026-05-01 11:09:06.528669+01	\N	\N
935	4	4	GET	/api/v1/ds_2_sales_seed	200	254	2026-05-09 15:19:26.244546+01	\N	\N
936	4	4	GET	/api/v1/ds_2_sales_seed/1	200	257	2026-04-27 02:53:56.438487+01	\N	\N
937	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	16	2026-04-28 13:55:03.283402+01	\N	\N
938	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	197	2026-05-01 07:34:48.8822+01	\N	\N
939	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	74	2026-04-15 11:01:28.037212+01	\N	\N
940	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	245	2026-04-14 08:21:19.279236+01	\N	\N
941	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	193	2026-04-23 05:28:32.654983+01	\N	\N
942	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	97	2026-05-12 15:59:49.119802+01	\N	\N
943	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	207	2026-04-15 08:34:05.067886+01	\N	\N
944	4	4	GET	/api/v1/ds_2_sales_seed/1	200	130	2026-04-15 23:45:55.709182+01	\N	\N
945	4	4	GET	/api/v1/ds_2_sales_seed	200	35	2026-04-25 18:51:42.256894+01	\N	\N
946	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	94	2026-04-29 17:51:02.527874+01	\N	\N
947	4	4	GET	/api/v1/ds_2_sales_seed/1	200	150	2026-04-23 14:50:28.892106+01	\N	\N
948	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	219	2026-04-29 22:31:28.043489+01	\N	\N
949	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	404	166	2026-05-04 05:38:15.785772+01	\N	\N
950	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	106	2026-05-03 02:54:40.564284+01	\N	\N
951	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	234	2026-04-30 11:50:20.055868+01	\N	\N
952	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	149	2026-05-08 10:40:00.190543+01	\N	\N
953	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	215	2026-05-13 13:01:37.335162+01	\N	\N
954	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	34	2026-04-29 11:55:23.409205+01	\N	\N
955	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	164	2026-04-18 03:36:31.299155+01	\N	\N
956	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	30	2026-04-23 20:30:42.010116+01	\N	\N
957	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	86	2026-04-28 06:58:41.513472+01	\N	\N
958	4	4	GET	/api/v1/ds_2_sales_seed/1	200	241	2026-04-24 05:34:23.219416+01	\N	\N
959	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	64	2026-04-25 21:34:54.111577+01	\N	\N
960	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	404	173	2026-04-14 17:25:04.271668+01	\N	\N
961	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	72	2026-04-16 04:15:35.375249+01	\N	\N
962	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	89	2026-05-08 21:58:22.617826+01	\N	\N
963	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	65	2026-04-23 06:52:02.220279+01	\N	\N
964	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	87	2026-05-11 19:14:52.39595+01	\N	\N
965	4	4	GET	/api/v1/ds_2_sales_seed/1	200	214	2026-04-21 06:31:34.682465+01	\N	\N
966	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	196	2026-05-06 04:59:16.87347+01	\N	\N
967	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	87	2026-04-18 08:54:05.218264+01	\N	\N
968	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	404	139	2026-05-08 19:53:29.515403+01	\N	\N
969	4	4	GET	/api/v1/ds_2_sales_seed/1	200	120	2026-04-30 02:20:32.17994+01	\N	\N
970	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	72	2026-05-13 11:29:40.492156+01	\N	\N
971	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	69	2026-04-21 12:51:50.600086+01	\N	\N
972	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	113	2026-05-06 03:18:18.445986+01	\N	\N
973	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	159	2026-04-21 10:30:20.900827+01	\N	\N
974	4	4	GET	/api/v1/ds_2_sales_seed?page=2	404	173	2026-05-03 13:38:39.059907+01	\N	\N
975	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	90	2026-04-18 18:39:15.572686+01	\N	\N
976	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	256	2026-04-21 20:39:59.408207+01	\N	\N
977	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	403	212	2026-04-15 12:21:55.500389+01	\N	\N
978	4	4	GET	/api/v1/ds_2_sales_seed/1	200	33	2026-04-20 07:46:03.755058+01	\N	\N
979	4	4	GET	/api/v1/ds_2_sales_seed	200	246	2026-05-07 17:38:40.014453+01	\N	\N
980	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	222	2026-05-12 01:23:12.779604+01	\N	\N
981	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	100	2026-04-25 22:11:47.244478+01	\N	\N
982	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	25	2026-05-13 12:30:35.012265+01	\N	\N
983	4	4	GET	/api/v1/ds_2_sales_seed/1	200	267	2026-04-16 20:24:08.591549+01	\N	\N
984	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	403	225	2026-05-08 12:38:34.817465+01	\N	\N
985	4	4	GET	/api/v1/ds_2_sales_seed/1	200	264	2026-05-11 02:02:53.001579+01	\N	\N
986	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	115	2026-05-11 03:36:12.213572+01	\N	\N
987	4	4	GET	/api/v1/ds_2_sales_seed?page=2	403	143	2026-05-10 05:32:26.0727+01	\N	\N
988	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	251	2026-05-04 23:48:42.247836+01	\N	\N
989	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	125	2026-04-14 06:04:39.853491+01	\N	\N
990	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	143	2026-04-14 11:52:17.879535+01	\N	\N
991	4	4	GET	/api/v1/ds_2_sales_seed/1	200	271	2026-05-05 18:57:48.520926+01	\N	\N
992	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	189	2026-04-28 22:54:46.252048+01	\N	\N
993	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	48	2026-04-27 10:18:11.934916+01	\N	\N
994	4	4	GET	/api/v1/ds_2_sales_seed/1	200	165	2026-05-12 20:22:13.177996+01	\N	\N
995	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	172	2026-05-04 19:19:25.496751+01	\N	\N
996	4	4	GET	/api/v1/ds_2_sales_seed	200	229	2026-05-13 00:20:34.809517+01	\N	\N
997	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	204	2026-04-20 04:20:02.606452+01	\N	\N
998	4	4	GET	/api/v1/ds_2_sales_seed	200	276	2026-05-08 03:48:41.677234+01	\N	\N
999	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	137	2026-05-07 14:33:15.397615+01	\N	\N
1000	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	23	2026-05-07 04:36:15.591515+01	\N	\N
1001	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	149	2026-05-04 13:33:39.965189+01	\N	\N
1002	4	4	GET	/api/v1/ds_2_sales_seed	200	72	2026-05-04 00:24:30.762484+01	\N	\N
1003	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	12	2026-05-10 18:44:31.934474+01	\N	\N
1004	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	44	2026-05-04 23:57:07.006261+01	\N	\N
1005	4	4	GET	/api/v1/ds_2_sales_seed/1	200	197	2026-04-21 21:59:51.216072+01	\N	\N
1006	4	4	GET	/api/v1/ds_2_sales_seed?page=2	403	42	2026-05-08 09:39:26.884955+01	\N	\N
1007	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	222	2026-04-27 09:00:12.623984+01	\N	\N
1008	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	164	2026-05-11 00:21:25.125094+01	\N	\N
1009	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	64	2026-04-28 04:03:50.138842+01	\N	\N
1010	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	180	2026-05-03 08:37:41.251672+01	\N	\N
1011	4	4	GET	/api/v1/ds_2_sales_seed/1	200	184	2026-05-06 11:34:51.887968+01	\N	\N
1012	4	4	GET	/api/v1/ds_2_sales_seed	200	223	2026-05-12 23:54:31.148071+01	\N	\N
1013	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	273	2026-04-23 16:44:33.319613+01	\N	\N
1014	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	208	2026-04-25 19:10:21.596671+01	\N	\N
1015	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	274	2026-04-28 15:42:58.268544+01	\N	\N
1016	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	133	2026-04-15 03:25:01.471579+01	\N	\N
1017	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	236	2026-05-11 15:39:07.283957+01	\N	\N
1018	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	198	2026-04-17 11:19:45.835762+01	\N	\N
1019	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	124	2026-05-09 19:13:17.406328+01	\N	\N
1020	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	261	2026-05-12 07:55:59.12445+01	\N	\N
1021	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	191	2026-05-09 03:38:12.478269+01	\N	\N
1022	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	245	2026-04-15 03:20:44.257804+01	\N	\N
1023	4	4	GET	/api/v1/ds_2_sales_seed	200	160	2026-04-21 10:34:47.563002+01	\N	\N
1024	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	280	2026-04-25 23:36:14.834694+01	\N	\N
1025	4	4	GET	/api/v1/ds_2_sales_seed	200	47	2026-04-30 17:16:15.976827+01	\N	\N
1026	4	4	GET	/api/v1/ds_2_sales_seed	200	215	2026-05-10 01:31:53.633578+01	\N	\N
1027	4	4	GET	/api/v1/ds_2_sales_seed	404	180	2026-04-26 08:53:37.240692+01	\N	\N
1028	4	4	GET	/api/v1/ds_2_sales_seed?page=2	403	16	2026-04-15 03:09:46.146997+01	\N	\N
1029	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	253	2026-04-14 10:23:20.44091+01	\N	\N
1030	4	4	GET	/api/v1/ds_2_sales_seed/1	404	177	2026-05-10 06:36:28.690789+01	\N	\N
1031	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	90	2026-04-27 07:13:37.278957+01	\N	\N
1032	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	121	2026-04-20 17:47:50.42913+01	\N	\N
1033	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	186	2026-05-11 18:37:11.97321+01	\N	\N
1034	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	76	2026-05-07 01:41:48.960243+01	\N	\N
1035	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	185	2026-04-25 10:09:22.893984+01	\N	\N
1036	4	4	GET	/api/v1/ds_2_sales_seed/1	200	36	2026-04-19 02:54:31.466971+01	\N	\N
1037	4	4	GET	/api/v1/ds_2_sales_seed	200	77	2026-05-07 11:44:14.209257+01	\N	\N
1038	4	4	GET	/api/v1/ds_2_sales_seed/1	200	118	2026-04-21 13:30:54.228428+01	\N	\N
1039	4	4	GET	/api/v1/ds_2_sales_seed/schema	404	252	2026-04-18 02:35:18.626104+01	\N	\N
1040	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	181	2026-04-18 22:41:22.054803+01	\N	\N
1041	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	185	2026-05-12 14:18:53.700472+01	\N	\N
1042	4	4	GET	/api/v1/ds_2_sales_seed	200	155	2026-04-16 15:07:23.57828+01	\N	\N
1043	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	212	2026-04-16 12:52:55.052439+01	\N	\N
1044	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	131	2026-04-28 22:00:52.08663+01	\N	\N
1045	4	4	GET	/api/v1/ds_2_sales_seed/1	200	278	2026-04-27 00:39:05.700463+01	\N	\N
1046	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	189	2026-04-22 01:32:57.171015+01	\N	\N
1047	4	4	GET	/api/v1/ds_2_sales_seed	200	227	2026-05-12 05:06:34.764942+01	\N	\N
1048	4	4	GET	/api/v1/ds_2_sales_seed	200	124	2026-05-04 16:48:38.109361+01	\N	\N
1049	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	89	2026-04-25 04:36:34.243382+01	\N	\N
1050	4	4	GET	/api/v1/ds_2_sales_seed/1	200	226	2026-05-11 21:24:02.387234+01	\N	\N
1051	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	231	2026-05-02 03:13:21.987323+01	\N	\N
1052	4	4	GET	/api/v1/ds_2_sales_seed/1	200	255	2026-05-12 22:09:43.919533+01	\N	\N
1053	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	214	2026-05-11 10:07:35.862189+01	\N	\N
1054	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	220	2026-04-28 04:50:35.469486+01	\N	\N
1055	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	230	2026-05-01 08:09:34.39915+01	\N	\N
1056	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	110	2026-04-16 05:29:31.770244+01	\N	\N
1057	4	4	GET	/api/v1/ds_2_sales_seed	200	143	2026-05-12 03:35:40.317115+01	\N	\N
1058	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	144	2026-04-26 20:02:22.044566+01	\N	\N
1059	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	228	2026-04-30 05:21:38.737058+01	\N	\N
1060	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	66	2026-04-22 18:39:54.385048+01	\N	\N
1061	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	111	2026-04-13 18:53:58.364139+01	\N	\N
1062	4	4	GET	/api/v1/ds_2_sales_seed/1	200	12	2026-04-28 05:31:24.20764+01	\N	\N
1063	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	190	2026-05-01 19:33:27.362358+01	\N	\N
1064	4	4	GET	/api/v1/ds_2_sales_seed/1	200	170	2026-05-10 21:09:11.36372+01	\N	\N
1065	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	76	2026-05-08 12:11:45.985725+01	\N	\N
1066	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	41	2026-04-26 05:30:50.180397+01	\N	\N
1067	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	204	2026-04-14 04:01:56.149349+01	\N	\N
1068	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	206	2026-04-24 01:46:30.01046+01	\N	\N
1069	4	4	GET	/api/v1/ds_2_sales_seed	200	43	2026-04-13 15:48:44.881685+01	\N	\N
1070	4	4	GET	/api/v1/ds_2_sales_seed/schema	403	204	2026-04-17 21:04:18.437067+01	\N	\N
1071	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	87	2026-04-22 14:33:47.513201+01	\N	\N
1072	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	272	2026-05-07 04:20:06.662837+01	\N	\N
1073	4	4	GET	/api/v1/ds_2_sales_seed	200	233	2026-04-24 21:47:50.048451+01	\N	\N
1074	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	279	2026-04-27 16:40:35.235509+01	\N	\N
1075	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	157	2026-04-21 08:50:19.116741+01	\N	\N
1076	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	24	2026-04-26 05:47:54.853353+01	\N	\N
1077	4	4	GET	/api/v1/ds_2_sales_seed/1	200	271	2026-04-16 07:37:23.442118+01	\N	\N
1078	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	69	2026-05-12 08:32:51.965477+01	\N	\N
1079	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	98	2026-04-19 11:43:27.035393+01	\N	\N
1080	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	243	2026-04-23 22:20:52.716869+01	\N	\N
1081	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	25	2026-05-02 17:55:20.079938+01	\N	\N
1082	4	4	GET	/api/v1/ds_2_sales_seed/schema	403	187	2026-05-08 08:28:48.146976+01	\N	\N
1083	4	4	GET	/api/v1/ds_2_sales_seed	200	90	2026-05-03 07:56:35.730978+01	\N	\N
1084	4	4	GET	/api/v1/ds_2_sales_seed/1	200	227	2026-04-19 05:11:01.778398+01	\N	\N
1085	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	22	2026-05-08 06:56:35.576451+01	\N	\N
1086	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	128	2026-05-07 15:04:26.775718+01	\N	\N
1087	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	207	2026-04-21 10:28:37.491112+01	\N	\N
1088	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	127	2026-04-27 21:00:49.040878+01	\N	\N
1089	4	4	GET	/api/v1/ds_2_sales_seed	200	90	2026-04-23 05:02:49.016733+01	\N	\N
1090	4	4	GET	/api/v1/ds_2_sales_seed	200	193	2026-05-09 20:01:08.913286+01	\N	\N
1091	4	4	GET	/api/v1/ds_2_sales_seed/1	200	259	2026-04-23 00:10:58.153042+01	\N	\N
1092	4	4	GET	/api/v1/ds_2_sales_seed/1	200	49	2026-05-07 22:24:01.331546+01	\N	\N
1093	4	4	GET	/api/v1/ds_2_sales_seed	200	106	2026-04-25 22:35:32.988286+01	\N	\N
1094	4	4	GET	/api/v1/ds_2_sales_seed	200	66	2026-04-16 15:54:14.324959+01	\N	\N
1095	4	4	GET	/api/v1/ds_2_sales_seed	200	87	2026-04-15 01:02:21.396269+01	\N	\N
1096	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	160	2026-04-14 04:58:29.393887+01	\N	\N
1097	4	4	GET	/api/v1/ds_2_sales_seed/1	200	143	2026-05-05 10:04:55.659508+01	\N	\N
1098	4	4	GET	/api/v1/ds_2_sales_seed/1	200	233	2026-04-15 00:03:56.687243+01	\N	\N
1099	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	224	2026-04-25 02:18:52.319575+01	\N	\N
1100	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	29	2026-04-17 14:06:14.950035+01	\N	\N
1101	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	155	2026-04-30 11:55:30.979946+01	\N	\N
1102	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	177	2026-05-09 05:07:40.844682+01	\N	\N
1103	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	93	2026-05-02 19:48:42.467956+01	\N	\N
1104	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	249	2026-04-18 12:34:57.756887+01	\N	\N
1105	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	36	2026-04-25 12:53:18.096059+01	\N	\N
1106	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	78	2026-04-17 13:05:38.774781+01	\N	\N
1107	4	4	GET	/api/v1/ds_2_sales_seed/1	200	205	2026-05-06 14:41:32.3646+01	\N	\N
1108	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	254	2026-05-04 10:20:54.653719+01	\N	\N
1109	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	8	2026-04-28 17:02:27.066591+01	\N	\N
1110	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	33	2026-04-30 22:02:04.930384+01	\N	\N
1111	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	101	2026-05-11 06:13:10.447313+01	\N	\N
1112	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	102	2026-04-20 03:13:48.633149+01	\N	\N
1113	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	40	2026-04-29 09:38:17.530091+01	\N	\N
1114	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	62	2026-05-04 11:20:08.570864+01	\N	\N
1115	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	403	64	2026-04-29 01:45:18.734859+01	\N	\N
1116	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	176	2026-04-27 16:27:52.108061+01	\N	\N
1117	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	103	2026-05-08 19:55:45.618364+01	\N	\N
1118	4	4	GET	/api/v1/ds_2_sales_seed?page=2	403	216	2026-04-24 22:53:42.327562+01	\N	\N
1119	4	4	GET	/api/v1/ds_2_sales_seed	200	141	2026-04-28 23:35:35.188518+01	\N	\N
1120	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	68	2026-05-13 10:20:29.25729+01	\N	\N
1121	4	4	GET	/api/v1/ds_2_sales_seed/1	403	188	2026-05-11 09:27:46.561192+01	\N	\N
1122	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	137	2026-04-19 06:55:29.195779+01	\N	\N
1123	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	89	2026-04-17 10:51:56.921455+01	\N	\N
1124	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	259	2026-04-14 02:32:04.10873+01	\N	\N
1125	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	242	2026-05-05 16:21:31.758808+01	\N	\N
1126	4	4	GET	/api/v1/ds_2_sales_seed	200	108	2026-04-17 12:05:58.512244+01	\N	\N
1127	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	151	2026-05-10 16:26:07.761569+01	\N	\N
1128	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	140	2026-05-01 23:22:38.313979+01	\N	\N
1129	4	4	GET	/api/v1/ds_2_sales_seed/1	200	48	2026-05-03 05:28:47.256769+01	\N	\N
1130	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	105	2026-04-30 09:41:09.171738+01	\N	\N
1131	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	152	2026-05-02 05:26:31.898046+01	\N	\N
1132	4	4	GET	/api/v1/ds_2_sales_seed	200	213	2026-04-24 11:46:04.58874+01	\N	\N
1133	4	4	GET	/api/v1/ds_2_sales_seed	200	53	2026-05-05 15:10:08.524814+01	\N	\N
1134	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	139	2026-05-09 05:12:04.831277+01	\N	\N
1135	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	37	2026-05-02 08:38:40.715638+01	\N	\N
1136	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	131	2026-04-23 20:23:16.718976+01	\N	\N
1137	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	276	2026-04-22 22:51:22.670282+01	\N	\N
1138	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	257	2026-04-24 02:19:39.99285+01	\N	\N
1139	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	147	2026-04-28 11:10:14.920989+01	\N	\N
1140	4	4	GET	/api/v1/ds_2_sales_seed	200	36	2026-04-18 13:56:48.37132+01	\N	\N
1141	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	97	2026-04-23 12:39:28.839362+01	\N	\N
1142	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	30	2026-04-26 17:49:58.928874+01	\N	\N
1143	4	4	GET	/api/v1/ds_2_sales_seed/1	200	130	2026-05-10 14:03:44.381548+01	\N	\N
1144	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	36	2026-05-10 12:28:24.638714+01	\N	\N
1145	4	4	GET	/api/v1/ds_2_sales_seed/schema	404	161	2026-05-03 14:47:14.109642+01	\N	\N
1146	4	4	GET	/api/v1/ds_2_sales_seed/1	200	32	2026-04-19 12:11:35.431243+01	\N	\N
1147	4	4	GET	/api/v1/ds_2_sales_seed?page=2	404	245	2026-04-30 12:44:09.462226+01	\N	\N
1148	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	219	2026-04-24 22:19:56.287492+01	\N	\N
1149	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	158	2026-04-25 13:11:47.882747+01	\N	\N
1150	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	212	2026-04-25 10:02:53.216486+01	\N	\N
1151	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	32	2026-05-04 09:10:03.277349+01	\N	\N
1152	4	4	GET	/api/v1/ds_2_sales_seed/schema	200	269	2026-05-13 09:10:49.549203+01	\N	\N
1153	4	4	GET	/api/v1/ds_2_sales_seed	200	28	2026-04-22 04:08:51.185354+01	\N	\N
1154	4	4	GET	/api/v1/ds_2_sales_seed	200	242	2026-05-06 03:12:18.557761+01	\N	\N
1155	4	4	GET	/api/v1/ds_2_sales_seed/1	200	240	2026-04-24 15:35:31.125467+01	\N	\N
1156	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	250	2026-04-29 20:01:57.072421+01	\N	\N
1157	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	36	2026-04-27 06:30:10.622471+01	\N	\N
1158	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	73	2026-04-13 18:19:04.552129+01	\N	\N
1159	4	4	GET	/api/v1/ds_2_sales_seed?region=Europe	200	87	2026-04-27 09:19:46.409232+01	\N	\N
1160	4	4	GET	/api/v1/ds_2_sales_seed/1	200	269	2026-04-30 23:48:07.035849+01	\N	\N
1161	4	4	GET	/api/v1/ds_2_sales_seed/1	200	167	2026-04-20 09:07:44.530848+01	\N	\N
1162	4	4	GET	/api/v1/ds_2_sales_seed	200	213	2026-04-23 21:52:11.507121+01	\N	\N
1163	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	13	2026-05-03 04:53:23.053514+01	\N	\N
1164	4	4	GET	/api/v1/ds_2_sales_seed?page=2	200	95	2026-04-24 19:57:11.540968+01	\N	\N
1165	4	4	GET	/api/v1/ds_2_sales_seed?status=paid	200	204	2026-04-27 18:16:04.227799+01	\N	\N
1166	6	9	GET	/api/v1/ds_4_product_inventory_0eb0727a	200	211	2026-05-14 22:37:27.647205+01	127.0.0.1	page=1&limit=100&order_by=string&order=asc&sku=string&sku__like=string&product_name=string&product_name__like=string&category=string&category__like=string&brand=string&brand__like=string&stock_qty=9105&stock_qty__gte=9105&stock_qty__lte=9105&reorder_level=9105&reorder_level__gte=9105&reorder_level__lte=9105&unit_cost=8213.101660017814&unit_cost__gte=8213.101660017814&unit_cost__lte=8213.101660017814&selling_price=8213.101660017814&selling_price__gte=8213.101660017814&selling_price__lte=8213.101660017814&warehouse=string&warehouse__like=string&last_restocked=string&last_restocked__like=string
1168	6	9	GET	/api/v1/ds_4_product_inventory_0eb0727a	200	194	2026-05-14 22:37:41.939832+01	127.0.0.1	\N
1170	6	9	GET	/api/v1/ds_4_product_inventory_0eb0727a/9105	404	190	2026-05-14 22:38:10.79681+01	127.0.0.1	\N
1171	6	9	GET	/api/v1/ds_4_product_inventory_0eb0727a/9105	404	196	2026-05-14 22:38:20.453244+01	127.0.0.1	\N
1172	7	10	GET	/api/v1/ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8	200	337	2026-05-14 23:28:33.810721+01	127.0.0.1	\N
1167	6	9	GET	/api/v1/ds_4_product_inventory_0eb0727a	200	195	2026-05-14 22:37:37.270358+01	127.0.0.1	page=1&limit=100&order_by=string&order=asc&sku=string&sku__like=string&product_name=string&product_name__like=string&category=string&category__like=string&brand=string&brand__like=string&stock_qty=9105&stock_qty__gte=9105&stock_qty__lte=9105&reorder_level=9105&reorder_level__gte=9105&reorder_level__lte=9105&unit_cost=8213.101660017814&unit_cost__gte=8213.101660017814&unit_cost__lte=8213.101660017814&selling_price=8213.101660017814&selling_price__gte=8213.101660017814&selling_price__lte=8213.101660017814&warehouse=string&warehouse__like=string&last_restocked=string&last_restocked__like=string
1169	6	9	GET	/api/v1/ds_4_product_inventory_0eb0727a	200	198	2026-05-14 22:37:56.205781+01	127.0.0.1	page=1&limit=100&order_by=string&order=asc&sku=string&sku__like=string&product_name=string&product_name__like=string&category=string&category__like=string&brand=string&brand__like=string&stock_qty=9105&stock_qty__gte=9105&stock_qty__lte=9105&reorder_level=9105&reorder_level__gte=9105&reorder_level__lte=9105&unit_cost=8213.101660017814&unit_cost__gte=8213.101660017814&unit_cost__lte=8213.101660017814&selling_price=8213.101660017814&selling_price__gte=8213.101660017814&selling_price__lte=8213.101660017814&warehouse=string&warehouse__like=string&last_restocked=string&last_restocked__like=string
1173	7	10	GET	/api/v1/ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8	200	336	2026-05-14 23:29:17.355153+01	127.0.0.1	\N
1174	8	11	GET	/api/v1/ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1	200	336	2026-05-14 23:32:01.449791+01	127.0.0.1	\N
1176	9	12	GET	/api/v1/ds_1_test_74ec9ab8	200	339	2026-05-14 23:38:54.353489+01	127.0.0.1	\N
1175	9	12	GET	/api/v1/ds_1_test_74ec9ab8	200	335	2026-05-14 23:37:53.401761+01	127.0.0.1	\N
\.


--
-- Data for Name: conversation_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conversation_messages (id, dataset_id, role, content, created_at) FROM stdin;
1	1	assistant	I found 4 columns in your file: **invoice_id, customer_name, amount, status**.\n\nDoes this look correct, or would you like to rename or hide any columns?	2026-05-13 14:03:01.538617+01
2	1	user	Looks good! Can you describe what the amount column means?	2026-05-13 14:03:01.538621+01
3	1	assistant	Sure! The `amount` column contains numeric values — it looks like it represents monetary amounts (currency). I've set its type to `number`. Should I keep it as-is?	2026-05-13 14:03:01.538622+01
4	1	user	Yes, that's perfect. Let's go with this.	2026-05-13 14:03:01.538622+01
5	1	assistant	Great! Your schema is confirmed. Click **Confirm & Create API** whenever you're ready to go live.	2026-05-13 14:03:01.538623+01
6	2	assistant	I found 4 columns in your file: **product_id, name, category, price**.\n\nDoes this look correct, or would you like to rename or hide any columns?	2026-05-13 14:03:01.933557+01
7	2	user	Looks good! Can you describe what the amount column means?	2026-05-13 14:03:01.933561+01
8	2	assistant	Sure! The `amount` column contains numeric values — it looks like it represents monetary amounts (currency). I've set its type to `number`. Should I keep it as-is?	2026-05-13 14:03:01.933562+01
9	2	user	Yes, that's perfect. Let's go with this.	2026-05-13 14:03:01.933563+01
10	2	assistant	Great! Your schema is confirmed. Click **Confirm & Create API** whenever you're ready to go live.	2026-05-13 14:03:01.933564+01
11	3	assistant	I found 4 columns in your file: **employee_id, full_name, department, role**.\n\nDoes this look correct, or would you like to rename or hide any columns?	2026-05-13 14:03:02.305544+01
12	3	user	Looks good! Can you describe what the amount column means?	2026-05-13 14:03:02.305546+01
13	3	assistant	Sure! The `amount` column contains numeric values — it looks like it represents monetary amounts (currency). I've set its type to `number`. Should I keep it as-is?	2026-05-13 14:03:02.305547+01
14	3	user	Yes, that's perfect. Let's go with this.	2026-05-13 14:03:02.305547+01
15	3	assistant	Great! Your schema is confirmed. Click **Confirm & Create API** whenever you're ready to go live.	2026-05-13 14:03:02.305548+01
16	4	assistant	I found 4 columns in your file: **sale_id, product, region, quantity**.\n\nDoes this look correct, or would you like to rename or hide any columns?	2026-05-13 14:03:02.692953+01
17	4	user	Looks good! Can you describe what the amount column means?	2026-05-13 14:03:02.692955+01
18	4	assistant	Sure! The `amount` column contains numeric values — it looks like it represents monetary amounts (currency). I've set its type to `number`. Should I keep it as-is?	2026-05-13 14:03:02.692955+01
19	4	user	Yes, that's perfect. Let's go with this.	2026-05-13 14:03:02.692956+01
20	4	assistant	Great! Your schema is confirmed. Click **Confirm & Create API** whenever you're ready to go live.	2026-05-13 14:03:02.692957+01
\.


--
-- Data for Name: datasets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.datasets (id, user_id, name, doc_type, original_filename, file_path, status, extracted_schema, confirmed_schema, table_name, row_count, created_at, updated_at, is_public, public_description, webhook_url, webhook_secret, sync_url, sync_interval_hours, last_synced_at, custom_endpoint) FROM stdin;
1	1	Customer Invoices	excel	invoices_q1_2026.xlsx	uploads/seed_invoices.csv	active	{"columns": [{"name": "invoice_id", "original_name": "Invoice ID", "type": "string", "description": "Unique invoice identifier", "expose": true}, {"name": "customer_name", "original_name": "Customer Name", "type": "string", "description": "Full name of the customer", "expose": true}, {"name": "amount", "original_name": "Amount", "type": "number", "description": "Invoice total in USD", "expose": true}, {"name": "status", "original_name": "Status", "type": "string", "description": "paid | pending | overdue", "expose": true}, {"name": "issue_date", "original_name": "Issue Date", "type": "datetime", "description": "Date invoice was issued", "expose": true}, {"name": "due_date", "original_name": "Due Date", "type": "datetime", "description": "Payment due date", "expose": true}], "row_count": 120}	{"columns": [{"name": "invoice_id", "original_name": "Invoice ID", "type": "string", "description": "Unique invoice identifier", "expose": true}, {"name": "customer_name", "original_name": "Customer Name", "type": "string", "description": "Full name of the customer", "expose": true}, {"name": "amount", "original_name": "Amount", "type": "number", "description": "Invoice total in USD", "expose": true}, {"name": "status", "original_name": "Status", "type": "string", "description": "paid | pending | overdue", "expose": true}, {"name": "issue_date", "original_name": "Issue Date", "type": "datetime", "description": "Date invoice was issued", "expose": true}, {"name": "due_date", "original_name": "Due Date", "type": "datetime", "description": "Payment due date", "expose": true}], "dataset_name": "Customer Invoices"}	ds_1_invoices_seed	120	2026-05-01 14:03:01.148359+01	2026-05-02 14:03:01.148367+01	f	\N	\N	\N	\N	\N	\N	\N
2	2	Product Catalog	csv	products_master.csv	uploads/seed_products.csv	active	{"columns": [{"name": "product_id", "original_name": "Product ID", "type": "string", "description": "SKU / product code", "expose": true}, {"name": "name", "original_name": "Name", "type": "string", "description": "Product display name", "expose": true}, {"name": "category", "original_name": "Category", "type": "string", "description": "Product category", "expose": true}, {"name": "price", "original_name": "Price", "type": "number", "description": "Retail price in USD", "expose": true}, {"name": "stock", "original_name": "Stock", "type": "integer", "description": "Units in stock", "expose": true}, {"name": "supplier", "original_name": "Supplier", "type": "string", "description": "Supplier company name", "expose": true}], "row_count": 80}	{"columns": [{"name": "product_id", "original_name": "Product ID", "type": "string", "description": "SKU / product code", "expose": true}, {"name": "name", "original_name": "Name", "type": "string", "description": "Product display name", "expose": true}, {"name": "category", "original_name": "Category", "type": "string", "description": "Product category", "expose": true}, {"name": "price", "original_name": "Price", "type": "number", "description": "Retail price in USD", "expose": true}, {"name": "stock", "original_name": "Stock", "type": "integer", "description": "Units in stock", "expose": true}, {"name": "supplier", "original_name": "Supplier", "type": "string", "description": "Supplier company name", "expose": true}], "dataset_name": "Product Catalog"}	ds_2_products_seed	80	2026-04-18 14:03:01.550193+01	2026-04-19 14:03:01.550196+01	f	\N	\N	\N	\N	\N	\N	\N
3	1	Employee Records	excel	hr_employees_2026.xlsx	uploads/seed_employees.csv	active	{"columns": [{"name": "employee_id", "original_name": "Employee ID", "type": "string", "description": "Internal employee ID", "expose": true}, {"name": "full_name", "original_name": "Full Name", "type": "string", "description": "Employee full name", "expose": true}, {"name": "department", "original_name": "Department", "type": "string", "description": "Team or department", "expose": true}, {"name": "role", "original_name": "Role", "type": "string", "description": "Job title", "expose": true}, {"name": "salary", "original_name": "Salary", "type": "number", "description": "Annual salary USD", "expose": false}, {"name": "hire_date", "original_name": "Hire Date", "type": "datetime", "description": "Date employee was hired", "expose": true}, {"name": "location", "original_name": "Location", "type": "string", "description": "Office or remote", "expose": true}], "row_count": 60}	{"columns": [{"name": "employee_id", "original_name": "Employee ID", "type": "string", "description": "Internal employee ID", "expose": true}, {"name": "full_name", "original_name": "Full Name", "type": "string", "description": "Employee full name", "expose": true}, {"name": "department", "original_name": "Department", "type": "string", "description": "Team or department", "expose": true}, {"name": "role", "original_name": "Role", "type": "string", "description": "Job title", "expose": true}, {"name": "salary", "original_name": "Salary", "type": "number", "description": "Annual salary USD", "expose": false}, {"name": "hire_date", "original_name": "Hire Date", "type": "datetime", "description": "Date employee was hired", "expose": true}, {"name": "location", "original_name": "Location", "type": "string", "description": "Office or remote", "expose": true}], "dataset_name": "Employee Records"}	ds_1_employees_seed	60	2026-05-06 14:03:01.939155+01	2026-05-07 14:03:01.939157+01	f	\N	\N	\N	\N	\N	\N	\N
4	2	Monthly Sales	csv	sales_jan_may_2026.csv	uploads/seed_sales.csv	active	{"columns": [{"name": "sale_id", "original_name": "Sale ID", "type": "string", "description": "Unique sale reference", "expose": true}, {"name": "product", "original_name": "Product", "type": "string", "description": "Product sold", "expose": true}, {"name": "region", "original_name": "Region", "type": "string", "description": "Sales region", "expose": true}, {"name": "quantity", "original_name": "Quantity", "type": "integer", "description": "Units sold", "expose": true}, {"name": "revenue", "original_name": "Revenue", "type": "number", "description": "Total revenue in USD", "expose": true}, {"name": "sale_date", "original_name": "Sale Date", "type": "datetime", "description": "Date of the sale", "expose": true}, {"name": "rep_name", "original_name": "Rep Name", "type": "string", "description": "Sales representative name", "expose": true}], "row_count": 200}	{"columns": [{"name": "sale_id", "original_name": "Sale ID", "type": "string", "description": "Unique sale reference", "expose": true}, {"name": "product", "original_name": "Product", "type": "string", "description": "Product sold", "expose": true}, {"name": "region", "original_name": "Region", "type": "string", "description": "Sales region", "expose": true}, {"name": "quantity", "original_name": "Quantity", "type": "integer", "description": "Units sold", "expose": true}, {"name": "revenue", "original_name": "Revenue", "type": "number", "description": "Total revenue in USD", "expose": true}, {"name": "sale_date", "original_name": "Sale Date", "type": "datetime", "description": "Date of the sale", "expose": true}, {"name": "rep_name", "original_name": "Rep Name", "type": "string", "description": "Sales representative name", "expose": true}], "dataset_name": "Monthly Sales"}	ds_2_sales_seed	200	2026-05-10 14:03:02.308962+01	2026-05-11 14:03:02.308964+01	f	\N	\N	\N	\N	\N	\N	\N
5	2	elderPA Notes and Plans 	excel	elderPA Notes and Plans .xlsx	uploads/ec4b1a9ece524f21a590b36146aa8d5a.xlsx	failed	{"columns": [{"name": "unnamed_0", "original_name": "Unnamed: 0", "type": "string", "description": "", "expose": true, "sample_values": ["ElderProfiles", "ElderChecklistItems", "Checklists", "CarePreferences", "CarePreferenceOptions"], "nullable": true}, {"name": "all_fileds", "original_name": "all fileds", "type": "number", "description": "", "expose": true, "sample_values": ["1.0", "1.0", "1.0", "1.0", "1.0"], "nullable": true}, {"name": "property", "original_name": "Property", "type": "string", "description": "", "expose": true, "sample_values": ["id", "user_id", "created_by", "entity_id", "temp_name"], "nullable": true}, {"name": "type", "original_name": "Type", "type": "string", "description": "", "expose": true, "sample_values": ["UID", "User", "User", "CoreEntities", "Varchar 70"], "nullable": true}, {"name": "is_unique", "original_name": "Is Unique?", "type": "string", "description": "", "expose": true, "sample_values": ["Yes", "Yes", "Yes", "Yes", "Yes"], "nullable": true}, {"name": "is_null", "original_name": "Is Null?", "type": "string", "description": "", "expose": true, "sample_values": ["No", "No", "No", "No", "No"], "nullable": true}, {"name": "ondelete", "original_name": "onDelete?", "type": "string", "description": "", "expose": true, "sample_values": ["set null", "cascade", "cascade", "set null", "set null"], "nullable": true}, {"name": "comment", "original_name": "Comment", "type": "string", "description": "", "expose": true, "sample_values": ["ACTIVE/IN_ACTIVE Default: IN_ACTIVE", "Default: Now", "Default: Now. Change value on update.", "Default: Now", "Default: Now. Change value on update."], "nullable": true}, {"name": "check_in_code", "original_name": "check in Code", "type": "number", "description": "", "expose": true, "sample_values": ["0.0", "0.0", "0.0", "0.0", "0.0"], "nullable": true}, {"name": "assignedto", "original_name": "AssignedTo", "type": "string", "description": "", "expose": true, "sample_values": ["Sangeetha", "Sangeetha", "PENDING", "Subeka", "default('IN_ACTIVE')"], "nullable": true}, {"name": "unnamed_10", "original_name": "Unnamed: 10", "type": "string", "description": "", "expose": true, "sample_values": ["fid=flow_id && pqid=previous_question_id && qoid=question_option_id", "[\\n        {\\n            \\"title\\": \\"15 minutes\\",\\n            \\"count\\": 15,\\n            \\"type\\": \\"MIN\\"\\n        },\\n        {\\n            \\"title\\": \\"1 week\\",\\n            \\"count\\": 1,\\n            \\"type\\": \\"WEEK\\"\\n        },\\n        {\\n            \\"title\\": \\"Single Person\\",\\n            \\"period\\": 1,\\n            \\"type\\": \\"PERSON\\"\\n        },\\n        {\\n            \\"title\\": \\"Couple\\",\\n            \\"period\\": 2,\\n            \\"type\\": \\"PERSON\\"\\n        }\\n    ]"], "nullable": true}, {"name": "new_json", "original_name": "new json", "type": "string", "description": "", "expose": true, "sample_values": [" [\\n        {\\n            \\"title\\": \\"15 minutes\\",\\n            \\"count\\": 15,\\n            \\"type\\": \\"MIN\\",\\n            \\"person\\": 2\\n        },\\n        {\\n            \\"title\\": \\"1 week\\",\\n            \\"count\\": 1,\\n            \\"type\\": \\"WEEK\\",\\n            \\"person\\": 1\\n        }\\n    ]", " [\\n        {\\n            \\"title\\": \\"weekend\\",\\n            \\"code\\": \\"weekend\\",\\n            \\"is_enabled\\": true\\n        },\\n        {\\n            \\"title\\": \\"night_hours\\",\\n            \\"code\\": \\"night_hours\\",\\n            \\"is_enabled\\": true\\n        }\\n    ]", "[\\n        {\\n            \\"title\\": \\"laundry charge\\",\\n            \\"code\\": \\"laundry_charge\\"\\n        },\\n        {\\n            \\"title\\": \\"parking_charge\\",\\n            \\"code\\": \\"parking_charge\\"\\n        },\\n        {\\n            \\"title\\": \\"escorting_to_appointments\\",\\n            \\"code\\": \\"escorting_to_appointments\\"\\n        },\\n        {\\n            \\"title\\": \\"one_to_one_charge\\",\\n            \\"code\\": \\"one_to_one_charge\\"\\n        }\\n    ]", "[\\n        {\\n            \\"title\\": \\"15 minutes\\",\\n            \\"count\\": 15,\\n            \\"type\\": \\"MIN\\", min, week\\n            'person': 2 //1,2,\\n            value: amount\\n        },\\n        {\\n            \\"title\\": \\"1 week\\",\\n            \\"count\\": 1,\\n            \\"type\\": \\"WEEK\\"\\n            'person': 1,\\n            value: amount\\n        }\\n    ]"], "nullable": true}], "row_count": 1197, "sheet_count": 1}	\N	\N	1197	2026-05-14 00:40:27.018503+01	2026-05-14 00:40:29.903478+01	f	\N	\N	\N	\N	\N	\N	\N
6	1	sales_orders	excel	sales_orders.xlsx	uploads/ccf2f9c441374608a36aa76cf2b2d4de.xlsx	failed	{"columns": [{"name": "order_id", "original_name": "order_id", "type": "string", "description": "", "expose": true, "sample_values": ["ORD-001", "ORD-002", "ORD-003", "ORD-004", "ORD-005"], "nullable": false, "flag": "identifier", "flag_color": "badge-info", "hint": "Unique identifier \\u2014 kept as string to preserve leading zeros/formats.", "confidence": 0.98}, {"name": "customer_name", "original_name": "customer_name", "type": "string", "description": "", "expose": true, "sample_values": ["Alice Johnson", "Bob Martinez", "Carol White", "David Lee", "Eva Chen"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "product", "original_name": "product", "type": "string", "description": "", "expose": true, "sample_values": ["Laptop Pro 15", "Wireless Headphones", "Office Chair Deluxe", "Standing Desk", "USB-C Hub 7-in-1"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "category", "original_name": "category", "type": "string", "description": "", "expose": true, "sample_values": ["Electronics", "Electronics", "Furniture", "Furniture", "Accessories"], "nullable": false, "flag": "enum", "flag_color": "badge-ghost", "hint": "Category field \\u2014 likely has a fixed set of values.", "confidence": 0.98}, {"name": "quantity", "original_name": "quantity", "type": "integer", "description": "", "expose": true, "sample_values": ["2", "5", "1", "1", "10"], "nullable": false, "flag": "count", "flag_color": "badge-ghost", "hint": "Count or quantity field.", "confidence": 0.98}, {"name": "unit_price", "original_name": "unit_price", "type": "number", "description": "", "expose": true, "sample_values": ["1299.99", "89.99", "349.0", "599.0", "45.99"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "total_amount", "original_name": "total_amount", "type": "number", "description": "", "expose": true, "sample_values": ["2599.98", "449.95", "349.0", "599.0", "459.9"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "order_date", "original_name": "order_date", "type": "string", "description": "", "expose": true, "sample_values": ["2024-01-05", "2024-01-07", "2024-01-10", "2024-01-12", "2024-01-15"], "nullable": false, "flag": "date", "flag_color": "badge-secondary", "hint": "Date/time field \\u2014 confirm format (MM/DD vs DD/MM) and timezone.", "confidence": 0.78}, {"name": "status", "original_name": "status", "type": "string", "description": "", "expose": true, "sample_values": ["Delivered", "Delivered", "Shipped", "Processing", "Delivered"], "nullable": false, "flag": "enum", "flag_color": "badge-ghost", "hint": "Category field \\u2014 likely has a fixed set of values.", "confidence": 0.98}, {"name": "region", "original_name": "region", "type": "string", "description": "", "expose": true, "sample_values": ["North", "South", "East", "West", "North"], "nullable": false, "flag": "location", "flag_color": "badge-ghost", "hint": "Location field.", "confidence": 0.98}], "row_count": 20, "sheet_count": 1, "data_preview": [{"order_id": "ORD-001", "customer_name": "Alice Johnson", "product": "Laptop Pro 15", "category": "Electronics", "quantity": "2", "unit_price": "1299.99", "total_amount": "2599.98", "order_date": "2024-01-05", "status": "Delivered", "region": "North"}, {"order_id": "ORD-002", "customer_name": "Bob Martinez", "product": "Wireless Headphones", "category": "Electronics", "quantity": "5", "unit_price": "89.99", "total_amount": "449.95", "order_date": "2024-01-07", "status": "Delivered", "region": "South"}, {"order_id": "ORD-003", "customer_name": "Carol White", "product": "Office Chair Deluxe", "category": "Furniture", "quantity": "1", "unit_price": "349.0", "total_amount": "349.0", "order_date": "2024-01-10", "status": "Shipped", "region": "East"}, {"order_id": "ORD-004", "customer_name": "David Lee", "product": "Standing Desk", "category": "Furniture", "quantity": "1", "unit_price": "599.0", "total_amount": "599.0", "order_date": "2024-01-12", "status": "Processing", "region": "West"}, {"order_id": "ORD-005", "customer_name": "Eva Chen", "product": "USB-C Hub 7-in-1", "category": "Accessories", "quantity": "10", "unit_price": "45.99", "total_amount": "459.9", "order_date": "2024-01-15", "status": "Delivered", "region": "North"}], "ai_mode": "chat", "confidence": 0.63}	{"columns": [{"name": "order_id", "original_name": "order_id", "type": "string", "description": "", "expose": true, "sample_values": ["ORD-001", "ORD-002", "ORD-003", "ORD-004", "ORD-005"], "nullable": false, "flag": "identifier", "flag_color": "badge-info", "hint": "Unique identifier \\u2014 kept as string to preserve leading zeros/formats.", "confidence": 0.98}, {"name": "customer_name", "original_name": "customer_name", "type": "string", "description": "", "expose": true, "sample_values": ["Alice Johnson", "Bob Martinez", "Carol White", "David Lee", "Eva Chen"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "product", "original_name": "product", "type": "string", "description": "", "expose": true, "sample_values": ["Laptop Pro 15", "Wireless Headphones", "Office Chair Deluxe", "Standing Desk", "USB-C Hub 7-in-1"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "category", "original_name": "category", "type": "string", "description": "", "expose": true, "sample_values": ["Electronics", "Electronics", "Furniture", "Furniture", "Accessories"], "nullable": false, "flag": "enum", "flag_color": "badge-ghost", "hint": "Category field \\u2014 likely has a fixed set of values.", "confidence": 0.98}, {"name": "quantity", "original_name": "quantity", "type": "integer", "description": "", "expose": true, "sample_values": ["2", "5", "1", "1", "10"], "nullable": false, "flag": "count", "flag_color": "badge-ghost", "hint": "Count or quantity field.", "confidence": 0.98}, {"name": "unit_price", "original_name": "unit_price", "type": "number", "description": "", "expose": true, "sample_values": ["1299.99", "89.99", "349.0", "599.0", "45.99"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "total_amount", "original_name": "total_amount", "type": "number", "description": "", "expose": true, "sample_values": ["2599.98", "449.95", "349.0", "599.0", "459.9"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "order_date", "original_name": "order_date", "type": "string", "description": "", "expose": true, "sample_values": ["2024-01-05", "2024-01-07", "2024-01-10", "2024-01-12", "2024-01-15"], "nullable": false, "flag": "date", "flag_color": "badge-secondary", "hint": "Date/time field \\u2014 confirm format (MM/DD vs DD/MM) and timezone.", "confidence": 0.78}, {"name": "status", "original_name": "status", "type": "string", "description": "", "expose": true, "sample_values": ["Delivered", "Delivered", "Shipped", "Processing", "Delivered"], "nullable": false, "flag": "enum", "flag_color": "badge-ghost", "hint": "Category field \\u2014 likely has a fixed set of values.", "confidence": 0.98}, {"name": "region", "original_name": "region", "type": "string", "description": "", "expose": true, "sample_values": ["North", "South", "East", "West", "North"], "nullable": false, "flag": "location", "flag_color": "badge-ghost", "hint": "Location field.", "confidence": 0.98}], "dataset_name": "sales_orders"}	\N	20	2026-05-14 14:21:20.2527+01	2026-05-14 14:21:20.665632+01	f	\N	\N	\N	\N	\N	\N	\N
7	1	sales_orders	excel	sales_orders.xlsx	uploads/edd4d881375b43b28a703038f303f5bc.xlsx	active	{"columns": [{"name": "order_id", "original_name": "order_id", "type": "string", "description": "", "expose": true, "sample_values": ["ORD-001", "ORD-002", "ORD-003", "ORD-004", "ORD-005"], "nullable": false, "flag": "identifier", "flag_color": "badge-info", "hint": "Unique identifier \\u2014 kept as string to preserve leading zeros/formats.", "confidence": 0.98}, {"name": "customer_name", "original_name": "customer_name", "type": "string", "description": "", "expose": true, "sample_values": ["Alice Johnson", "Bob Martinez", "Carol White", "David Lee", "Eva Chen"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "product", "original_name": "product", "type": "string", "description": "", "expose": true, "sample_values": ["Laptop Pro 15", "Wireless Headphones", "Office Chair Deluxe", "Standing Desk", "USB-C Hub 7-in-1"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "category", "original_name": "category", "type": "string", "description": "", "expose": true, "sample_values": ["Electronics", "Electronics", "Furniture", "Furniture", "Accessories"], "nullable": false, "flag": "enum", "flag_color": "badge-ghost", "hint": "Category field \\u2014 likely has a fixed set of values.", "confidence": 0.98}, {"name": "quantity", "original_name": "quantity", "type": "integer", "description": "", "expose": true, "sample_values": ["2", "5", "1", "1", "10"], "nullable": false, "flag": "count", "flag_color": "badge-ghost", "hint": "Count or quantity field.", "confidence": 0.98}, {"name": "unit_price", "original_name": "unit_price", "type": "number", "description": "", "expose": true, "sample_values": ["1299.99", "89.99", "349.0", "599.0", "45.99"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "total_amount", "original_name": "total_amount", "type": "number", "description": "", "expose": true, "sample_values": ["2599.98", "449.95", "349.0", "599.0", "459.9"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "order_date", "original_name": "order_date", "type": "string", "description": "", "expose": true, "sample_values": ["2024-01-05", "2024-01-07", "2024-01-10", "2024-01-12", "2024-01-15"], "nullable": false, "flag": "date", "flag_color": "badge-secondary", "hint": "Date/time field \\u2014 confirm format (MM/DD vs DD/MM) and timezone.", "confidence": 0.78}, {"name": "status", "original_name": "status", "type": "string", "description": "", "expose": true, "sample_values": ["Delivered", "Delivered", "Shipped", "Processing", "Delivered"], "nullable": false, "flag": "enum", "flag_color": "badge-ghost", "hint": "Category field \\u2014 likely has a fixed set of values.", "confidence": 0.98}, {"name": "region", "original_name": "region", "type": "string", "description": "", "expose": true, "sample_values": ["North", "South", "East", "West", "North"], "nullable": false, "flag": "location", "flag_color": "badge-ghost", "hint": "Location field.", "confidence": 0.98}], "row_count": 20, "sheet_count": 1, "data_preview": [{"order_id": "ORD-001", "customer_name": "Alice Johnson", "product": "Laptop Pro 15", "category": "Electronics", "quantity": "2", "unit_price": "1299.99", "total_amount": "2599.98", "order_date": "2024-01-05", "status": "Delivered", "region": "North"}, {"order_id": "ORD-002", "customer_name": "Bob Martinez", "product": "Wireless Headphones", "category": "Electronics", "quantity": "5", "unit_price": "89.99", "total_amount": "449.95", "order_date": "2024-01-07", "status": "Delivered", "region": "South"}, {"order_id": "ORD-003", "customer_name": "Carol White", "product": "Office Chair Deluxe", "category": "Furniture", "quantity": "1", "unit_price": "349.0", "total_amount": "349.0", "order_date": "2024-01-10", "status": "Shipped", "region": "East"}, {"order_id": "ORD-004", "customer_name": "David Lee", "product": "Standing Desk", "category": "Furniture", "quantity": "1", "unit_price": "599.0", "total_amount": "599.0", "order_date": "2024-01-12", "status": "Processing", "region": "West"}, {"order_id": "ORD-005", "customer_name": "Eva Chen", "product": "USB-C Hub 7-in-1", "category": "Accessories", "quantity": "10", "unit_price": "45.99", "total_amount": "459.9", "order_date": "2024-01-15", "status": "Delivered", "region": "North"}], "ai_mode": "editor", "confidence": 0.63}	{"columns": [{"name": "order_id", "original_name": "order_id", "type": "string", "description": "", "expose": true, "sample_values": ["ORD-001", "ORD-002", "ORD-003", "ORD-004", "ORD-005"], "nullable": false, "flag": "identifier", "flag_color": "badge-info", "hint": "Unique identifier \\u2014 kept as string to preserve leading zeros/formats.", "confidence": 0.98}, {"name": "customer_name", "original_name": "customer_name", "type": "string", "description": "", "expose": true, "sample_values": ["Alice Johnson", "Bob Martinez", "Carol White", "David Lee", "Eva Chen"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "product", "original_name": "product", "type": "string", "description": "", "expose": true, "sample_values": ["Laptop Pro 15", "Wireless Headphones", "Office Chair Deluxe", "Standing Desk", "USB-C Hub 7-in-1"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "category", "original_name": "category", "type": "string", "description": "", "expose": true, "sample_values": ["Electronics", "Electronics", "Furniture", "Furniture", "Accessories"], "nullable": false, "flag": "enum", "flag_color": "badge-ghost", "hint": "Category field \\u2014 likely has a fixed set of values.", "confidence": 0.98}, {"name": "quantity", "original_name": "quantity", "type": "integer", "description": "", "expose": true, "sample_values": ["2", "5", "1", "1", "10"], "nullable": false, "flag": "count", "flag_color": "badge-ghost", "hint": "Count or quantity field.", "confidence": 0.98}, {"name": "unit_price", "original_name": "unit_price", "type": "number", "description": "", "expose": true, "sample_values": ["1299.99", "89.99", "349.0", "599.0", "45.99"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "total_amount", "original_name": "total_amount", "type": "number", "description": "", "expose": true, "sample_values": ["2599.98", "449.95", "349.0", "599.0", "459.9"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "order_date", "original_name": "order_date", "type": "string", "description": "", "expose": true, "sample_values": ["2024-01-05", "2024-01-07", "2024-01-10", "2024-01-12", "2024-01-15"], "nullable": false, "flag": "date", "flag_color": "badge-secondary", "hint": "Date/time field \\u2014 confirm format (MM/DD vs DD/MM) and timezone.", "confidence": 0.78}, {"name": "status", "original_name": "status", "type": "string", "description": "", "expose": true, "sample_values": ["Delivered", "Delivered", "Shipped", "Processing", "Delivered"], "nullable": false, "flag": "enum", "flag_color": "badge-ghost", "hint": "Category field \\u2014 likely has a fixed set of values.", "confidence": 0.98}, {"name": "region", "original_name": "region", "type": "string", "description": "", "expose": true, "sample_values": ["North", "South", "East", "West", "North"], "nullable": false, "flag": "location", "flag_color": "badge-ghost", "hint": "Location field.", "confidence": 0.98}], "dataset_name": "sales_orders"}	ds_1_sales_orders_a50a19dd	20	2026-05-14 14:24:44.16293+01	2026-05-14 14:26:31.986583+01	t	\N	\N	\N	\N	\N	\N	\N
9	4	product_inventory	excel	product_inventory.xlsx	uploads/26ef0f912ae344a0944e71862d743df6.xlsx	active	{"columns": [{"name": "sku", "original_name": "sku", "type": "string", "description": "", "expose": true, "sample_values": ["SKU-1001", "SKU-1002", "SKU-1003", "SKU-1004", "SKU-1005"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "product_name", "original_name": "product_name", "type": "string", "description": "", "expose": true, "sample_values": ["Laptop Pro 15 i7", "Wireless Mouse Slim", "USB-C Dock Pro", "27\\" 4K Monitor", "Office Chair Mesh"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "category", "original_name": "category", "type": "string", "description": "", "expose": true, "sample_values": ["Electronics", "Accessories", "Accessories", "Electronics", "Furniture"], "nullable": false, "flag": "enum", "flag_color": "badge-ghost", "hint": "Category field \\u2014 likely has a fixed set of values.", "confidence": 0.98}, {"name": "brand", "original_name": "brand", "type": "string", "description": "", "expose": true, "sample_values": ["TechBrand", "ClickTech", "ConnectHub", "ViewClear", "ErgoSeat"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "stock_qty", "original_name": "stock_qty", "type": "integer", "description": "", "expose": true, "sample_values": ["45", "230", "78", "32", "19"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "reorder_level", "original_name": "reorder_level", "type": "integer", "description": "", "expose": true, "sample_values": ["10", "50", "20", "8", "5"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "unit_cost", "original_name": "unit_cost", "type": "number", "description": "", "expose": true, "sample_values": ["850.0", "12.5", "28.0", "320.0", "180.0"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "selling_price", "original_name": "selling_price", "type": "number", "description": "", "expose": true, "sample_values": ["1299.99", "39.99", "79.99", "549.99", "349.0"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "warehouse", "original_name": "warehouse", "type": "string", "description": "", "expose": true, "sample_values": ["WH-A", "WH-B", "WH-A", "WH-C", "WH-B"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "last_restocked", "original_name": "last_restocked", "type": "string", "description": "", "expose": true, "sample_values": ["2024-01-10", "2024-01-08", "2024-01-15", "2024-01-05", "2024-01-12"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}], "row_count": 20, "sheet_count": 1, "data_preview": [{"sku": "SKU-1001", "product_name": "Laptop Pro 15 i7", "category": "Electronics", "brand": "TechBrand", "stock_qty": "45", "reorder_level": "10", "unit_cost": "850.0", "selling_price": "1299.99", "warehouse": "WH-A", "last_restocked": "2024-01-10"}, {"sku": "SKU-1002", "product_name": "Wireless Mouse Slim", "category": "Accessories", "brand": "ClickTech", "stock_qty": "230", "reorder_level": "50", "unit_cost": "12.5", "selling_price": "39.99", "warehouse": "WH-B", "last_restocked": "2024-01-08"}, {"sku": "SKU-1003", "product_name": "USB-C Dock Pro", "category": "Accessories", "brand": "ConnectHub", "stock_qty": "78", "reorder_level": "20", "unit_cost": "28.0", "selling_price": "79.99", "warehouse": "WH-A", "last_restocked": "2024-01-15"}, {"sku": "SKU-1004", "product_name": "27\\" 4K Monitor", "category": "Electronics", "brand": "ViewClear", "stock_qty": "32", "reorder_level": "8", "unit_cost": "320.0", "selling_price": "549.99", "warehouse": "WH-C", "last_restocked": "2024-01-05"}, {"sku": "SKU-1005", "product_name": "Office Chair Mesh", "category": "Furniture", "brand": "ErgoSeat", "stock_qty": "19", "reorder_level": "5", "unit_cost": "180.0", "selling_price": "349.0", "warehouse": "WH-B", "last_restocked": "2024-01-12"}], "ai_mode": "editor", "confidence": 0.63}	{"columns": [{"name": "sku", "original_name": "sku", "type": "string", "description": "", "expose": true, "sample_values": ["SKU-1001", "SKU-1002", "SKU-1003", "SKU-1004", "SKU-1005"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "product_name", "original_name": "product_name", "type": "string", "description": "", "expose": true, "sample_values": ["Laptop Pro 15 i7", "Wireless Mouse Slim", "USB-C Dock Pro", "27\\" 4K Monitor", "Office Chair Mesh"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "category", "original_name": "category", "type": "string", "description": "", "expose": true, "sample_values": ["Electronics", "Accessories", "Accessories", "Electronics", "Furniture"], "nullable": false, "flag": "enum", "flag_color": "badge-ghost", "hint": "Category field \\u2014 likely has a fixed set of values.", "confidence": 0.98}, {"name": "brand", "original_name": "brand", "type": "string", "description": "", "expose": true, "sample_values": ["TechBrand", "ClickTech", "ConnectHub", "ViewClear", "ErgoSeat"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "stock_qty", "original_name": "stock_qty", "type": "integer", "description": "", "expose": true, "sample_values": ["45", "230", "78", "32", "19"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "reorder_level", "original_name": "reorder_level", "type": "integer", "description": "", "expose": true, "sample_values": ["10", "50", "20", "8", "5"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "unit_cost", "original_name": "unit_cost", "type": "number", "description": "", "expose": true, "sample_values": ["850.0", "12.5", "28.0", "320.0", "180.0"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "selling_price", "original_name": "selling_price", "type": "number", "description": "", "expose": true, "sample_values": ["1299.99", "39.99", "79.99", "549.99", "349.0"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "warehouse", "original_name": "warehouse", "type": "string", "description": "", "expose": true, "sample_values": ["WH-A", "WH-B", "WH-A", "WH-C", "WH-B"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "last_restocked", "original_name": "last_restocked", "type": "string", "description": "", "expose": true, "sample_values": ["2024-01-10", "2024-01-08", "2024-01-15", "2024-01-05", "2024-01-12"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}], "dataset_name": "product_inventory"}	ds_4_product_inventory_0eb0727a	20	2026-05-14 22:28:52.272368+01	2026-05-14 22:29:47.924084+01	f	\N	\N	\N	\N	\N	\N	\N
8	3	product_inventory	excel	product_inventory.xlsx	uploads/f109dd1b299a44e9ad5b13f19ec865b2.xlsx	active	{"columns": [{"name": "sku", "original_name": "sku", "type": "string", "description": "", "expose": true, "sample_values": ["SKU-1001", "SKU-1002", "SKU-1003", "SKU-1004", "SKU-1005"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "product_name", "original_name": "product_name", "type": "string", "description": "", "expose": true, "sample_values": ["Laptop Pro 15 i7", "Wireless Mouse Slim", "USB-C Dock Pro", "27\\" 4K Monitor", "Office Chair Mesh"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "category", "original_name": "category", "type": "string", "description": "", "expose": true, "sample_values": ["Electronics", "Accessories", "Accessories", "Electronics", "Furniture"], "nullable": false, "flag": "enum", "flag_color": "badge-ghost", "hint": "Category field \\u2014 likely has a fixed set of values.", "confidence": 0.98}, {"name": "brand", "original_name": "brand", "type": "string", "description": "", "expose": true, "sample_values": ["TechBrand", "ClickTech", "ConnectHub", "ViewClear", "ErgoSeat"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "stock_qty", "original_name": "stock_qty", "type": "integer", "description": "", "expose": true, "sample_values": ["45", "230", "78", "32", "19"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "reorder_level", "original_name": "reorder_level", "type": "integer", "description": "", "expose": true, "sample_values": ["10", "50", "20", "8", "5"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "unit_cost", "original_name": "unit_cost", "type": "number", "description": "", "expose": true, "sample_values": ["850.0", "12.5", "28.0", "320.0", "180.0"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "selling_price", "original_name": "selling_price", "type": "number", "description": "", "expose": true, "sample_values": ["1299.99", "39.99", "79.99", "549.99", "349.0"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "warehouse", "original_name": "warehouse", "type": "string", "description": "", "expose": true, "sample_values": ["WH-A", "WH-B", "WH-A", "WH-C", "WH-B"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "last_restocked", "original_name": "last_restocked", "type": "string", "description": "", "expose": true, "sample_values": ["2024-01-10", "2024-01-08", "2024-01-15", "2024-01-05", "2024-01-12"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}], "row_count": 20, "sheet_count": 1, "data_preview": [{"sku": "SKU-1001", "product_name": "Laptop Pro 15 i7", "category": "Electronics", "brand": "TechBrand", "stock_qty": "45", "reorder_level": "10", "unit_cost": "850.0", "selling_price": "1299.99", "warehouse": "WH-A", "last_restocked": "2024-01-10"}, {"sku": "SKU-1002", "product_name": "Wireless Mouse Slim", "category": "Accessories", "brand": "ClickTech", "stock_qty": "230", "reorder_level": "50", "unit_cost": "12.5", "selling_price": "39.99", "warehouse": "WH-B", "last_restocked": "2024-01-08"}, {"sku": "SKU-1003", "product_name": "USB-C Dock Pro", "category": "Accessories", "brand": "ConnectHub", "stock_qty": "78", "reorder_level": "20", "unit_cost": "28.0", "selling_price": "79.99", "warehouse": "WH-A", "last_restocked": "2024-01-15"}, {"sku": "SKU-1004", "product_name": "27\\" 4K Monitor", "category": "Electronics", "brand": "ViewClear", "stock_qty": "32", "reorder_level": "8", "unit_cost": "320.0", "selling_price": "549.99", "warehouse": "WH-C", "last_restocked": "2024-01-05"}, {"sku": "SKU-1005", "product_name": "Office Chair Mesh", "category": "Furniture", "brand": "ErgoSeat", "stock_qty": "19", "reorder_level": "5", "unit_cost": "180.0", "selling_price": "349.0", "warehouse": "WH-B", "last_restocked": "2024-01-12"}], "ai_mode": "editor", "confidence": 0.63}	{"columns": [{"name": "sku", "original_name": "sku", "type": "string", "description": "", "expose": true, "sample_values": ["SKU-1001", "SKU-1002", "SKU-1003", "SKU-1004", "SKU-1005"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "product_name", "original_name": "product_name", "type": "string", "description": "", "expose": true, "sample_values": ["Laptop Pro 15 i7", "Wireless Mouse Slim", "USB-C Dock Pro", "27\\" 4K Monitor", "Office Chair Mesh"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "category", "original_name": "category", "type": "string", "description": "", "expose": true, "sample_values": ["Electronics", "Accessories", "Accessories", "Electronics", "Furniture"], "nullable": false, "flag": "enum", "flag_color": "badge-ghost", "hint": "Category field \\u2014 likely has a fixed set of values.", "confidence": 0.98}, {"name": "brand", "original_name": "brand", "type": "string", "description": "", "expose": true, "sample_values": ["TechBrand", "ClickTech", "ConnectHub", "ViewClear", "ErgoSeat"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "stock_qty", "original_name": "stock_qty", "type": "integer", "description": "", "expose": true, "sample_values": ["45", "230", "78", "32", "19"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "reorder_level", "original_name": "reorder_level", "type": "integer", "description": "", "expose": true, "sample_values": ["10", "50", "20", "8", "5"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "unit_cost", "original_name": "unit_cost", "type": "number", "description": "", "expose": true, "sample_values": ["850.0", "12.5", "28.0", "320.0", "180.0"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "selling_price", "original_name": "selling_price", "type": "number", "description": "", "expose": true, "sample_values": ["1299.99", "39.99", "79.99", "549.99", "349.0"], "nullable": false, "flag": "currency", "flag_color": "badge-success", "hint": "Monetary value \\u2014 what currency is this? (USD, EUR, INR, GBP\\u2026)", "confidence": 0.98}, {"name": "warehouse", "original_name": "warehouse", "type": "string", "description": "", "expose": true, "sample_values": ["WH-A", "WH-B", "WH-A", "WH-C", "WH-B"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "last_restocked", "original_name": "last_restocked", "type": "string", "description": "", "expose": true, "sample_values": ["2024-01-10", "2024-01-08", "2024-01-15", "2024-01-05", "2024-01-12"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}], "dataset_name": "product_inventory"}	ds_3_product_inventory_4205c3ea	20	2026-05-14 14:28:40.454883+01	2026-05-14 14:28:52.631488+01	f	\N	\N	\N	\N	\N	\N	\N
10	4	BrEaST-Lesions-USG-clinical-data-Dec-15-2023	excel	BrEaST-Lesions-USG-clinical-data-Dec-15-2023.xlsx	uploads/554345e80feb46a8ae4d9cce80af1d8c.xlsx	active	{"columns": [{"name": "caseid", "original_name": "CaseID", "type": "integer", "description": "", "expose": true, "sample_values": ["1", "2", "3", "4", "5"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "image_filename", "original_name": "Image_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001.png", "case002.png", "case003.png", "case004.png", "case005.png"], "nullable": false, "flag": "url", "flag_color": "badge-ghost", "hint": "URL or image link field.", "confidence": 0.98}, {"name": "mask_tumor_filename", "original_name": "Mask_tumor_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001_tumor.png", "case002_tumor.png", "case003_tumor.png", "case004_tumor.png", "case005_tumor.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "mask_other_filename", "original_name": "Mask_other_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case022_other1.png&case022_other2.png", "case036_other1.png&case036_other2.png", "case038_other1.png", "case085_other1.png&case085_other2.png", "case092_other1.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "pixel_size", "original_name": "Pixel_size", "type": "number", "description": "", "expose": true, "sample_values": ["0.0078125", "0.006462036", "0.006944444", "0.0078125", "0.0078125"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "age", "original_name": "Age", "type": "string", "description": "", "expose": true, "sample_values": ["57", "not available", "56", "43", "67"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "tissue_composition", "original_name": "Tissue_composition", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous: predominantly fat", "homogeneous: fat", "heterogeneous: predominantly fat", "homogeneous: fibroglandular", "homogeneous: fat"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "signs", "original_name": "Signs", "type": "string", "description": "", "expose": true, "sample_values": ["breast scar", "not available", "no", "no", "nipple retraction&palpable"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "symptoms", "original_name": "Symptoms", "type": "string", "description": "", "expose": true, "sample_values": ["family history of breast/ovarian cancer", "not available", "nipple discharge", "no", "family history of breast/ovarian cancer"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "shape", "original_name": "Shape", "type": "string", "description": "", "expose": true, "sample_values": ["irregular", "oval", "oval", "round", "oval"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "margin", "original_name": "Margin", "type": "string", "description": "", "expose": true, "sample_values": ["not circumscribed - indistinct", "not circumscribed - indistinct", "circumscribed", "circumscribed", "circumscribed"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "echogenicity", "original_name": "Echogenicity", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous", "hypoechoic", "hyperechoic", "hypoechoic", "complex cystic/solid"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "posterior_features", "original_name": "Posterior_features", "type": "string", "description": "", "expose": true, "sample_values": ["shadowing", "no", "no", "no", "enhancement"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "halo", "original_name": "Halo", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "calcifications", "original_name": "Calcifications", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "skin_thickening", "original_name": "Skin_thickening", "type": "string", "description": "", "expose": true, "sample_values": ["yes", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "interpretation", "original_name": "Interpretation", "type": "string", "description": "", "expose": true, "sample_values": ["Breast scar (surgery)&Breast scar (radiotherapy)", "Dysplasia&Fibroadenoma", "Duct filled with thick fluid&Intraductal papilloma", "Cyst filled with thick fluid", "Suspicion of malignancy&Intraductal papilloma"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "birads", "original_name": "BIRADS", "type": "string", "description": "", "expose": true, "sample_values": ["2", "4b", "4a", "3", "4b"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "verification", "original_name": "Verification", "type": "string", "description": "", "expose": true, "sample_values": ["confirmed by follow-up care", "confirmed by biopsy", "confirmed by biopsy", "confirmed by follow-up care", "confirmed by biopsy"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "diagnosis", "original_name": "Diagnosis", "type": "string", "description": "", "expose": true, "sample_values": ["not applicable", "Intramammary lymph node", "Usual ductal hyperplasia (UDH)&Pseudoangiomatous stromal hyperplasia (PASH)", "not applicable", "Encapsulated papillary carcinoma&Ductal carcinoma in situ (DCIS)"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "classification", "original_name": "Classification", "type": "string", "description": "", "expose": true, "sample_values": ["benign", "benign", "benign", "benign", "malignant"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}], "row_count": 256, "sheet_count": 1, "data_preview": [{"CaseID": "1", "Image_filename": "case001.png", "Mask_tumor_filename": "case001_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.0078125", "Age": "57", "Tissue_composition": "heterogeneous: predominantly fat", "Signs": "breast scar", "Symptoms": "family history of breast/ovarian cancer", "Shape": "irregular", "Margin": "not circumscribed - indistinct", "Echogenicity": "heterogeneous", "Posterior_features": "shadowing", "Halo": "no", "Calcifications": "no", "Skin_thickening": "yes", "Interpretation": "Breast scar (surgery)&Breast scar (radiotherapy)", "BIRADS": "2", "Verification": "confirmed by follow-up care", "Diagnosis": "not applicable", "Classification": "benign"}, {"CaseID": "2", "Image_filename": "case002.png", "Mask_tumor_filename": "case002_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.006462036", "Age": "not available", "Tissue_composition": "homogeneous: fat", "Signs": "not available", "Symptoms": "not available", "Shape": "oval", "Margin": "not circumscribed - indistinct", "Echogenicity": "hypoechoic", "Posterior_features": "no", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Dysplasia&Fibroadenoma", "BIRADS": "4b", "Verification": "confirmed by biopsy", "Diagnosis": "Intramammary lymph node", "Classification": "benign"}, {"CaseID": "3", "Image_filename": "case003.png", "Mask_tumor_filename": "case003_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.006944444", "Age": "56", "Tissue_composition": "heterogeneous: predominantly fat", "Signs": "no", "Symptoms": "nipple discharge", "Shape": "oval", "Margin": "circumscribed", "Echogenicity": "hyperechoic", "Posterior_features": "no", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Duct filled with thick fluid&Intraductal papilloma", "BIRADS": "4a", "Verification": "confirmed by biopsy", "Diagnosis": "Usual ductal hyperplasia (UDH)&Pseudoangiomatous stromal hyperplasia (PASH)", "Classification": "benign"}, {"CaseID": "4", "Image_filename": "case004.png", "Mask_tumor_filename": "case004_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.0078125", "Age": "43", "Tissue_composition": "homogeneous: fibroglandular", "Signs": "no", "Symptoms": "no", "Shape": "round", "Margin": "circumscribed", "Echogenicity": "hypoechoic", "Posterior_features": "no", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Cyst filled with thick fluid", "BIRADS": "3", "Verification": "confirmed by follow-up care", "Diagnosis": "not applicable", "Classification": "benign"}, {"CaseID": "5", "Image_filename": "case005.png", "Mask_tumor_filename": "case005_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.0078125", "Age": "67", "Tissue_composition": "homogeneous: fat", "Signs": "nipple retraction&palpable", "Symptoms": "family history of breast/ovarian cancer", "Shape": "oval", "Margin": "circumscribed", "Echogenicity": "complex cystic/solid", "Posterior_features": "enhancement", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Suspicion of malignancy&Intraductal papilloma", "BIRADS": "4b", "Verification": "confirmed by biopsy", "Diagnosis": "Encapsulated papillary carcinoma&Ductal carcinoma in situ (DCIS)", "Classification": "malignant"}], "ai_mode": "editor", "confidence": 0.63}	{"columns": [{"name": "caseid", "original_name": "CaseID", "type": "integer", "description": "", "expose": true, "sample_values": ["1", "2", "3", "4", "5"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "image_filename", "original_name": "Image_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001.png", "case002.png", "case003.png", "case004.png", "case005.png"], "nullable": false, "flag": "url", "flag_color": "badge-ghost", "hint": "URL or image link field.", "confidence": 0.98}, {"name": "mask_tumor_filename", "original_name": "Mask_tumor_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001_tumor.png", "case002_tumor.png", "case003_tumor.png", "case004_tumor.png", "case005_tumor.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "mask_other_filename", "original_name": "Mask_other_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case022_other1.png&case022_other2.png", "case036_other1.png&case036_other2.png", "case038_other1.png", "case085_other1.png&case085_other2.png", "case092_other1.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "pixel_size", "original_name": "Pixel_size", "type": "number", "description": "", "expose": true, "sample_values": ["0.0078125", "0.006462036", "0.006944444", "0.0078125", "0.0078125"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "age", "original_name": "Age", "type": "string", "description": "", "expose": true, "sample_values": ["57", "not available", "56", "43", "67"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "tissue_composition", "original_name": "Tissue_composition", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous: predominantly fat", "homogeneous: fat", "heterogeneous: predominantly fat", "homogeneous: fibroglandular", "homogeneous: fat"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "signs", "original_name": "Signs", "type": "string", "description": "", "expose": true, "sample_values": ["breast scar", "not available", "no", "no", "nipple retraction&palpable"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "symptoms", "original_name": "Symptoms", "type": "string", "description": "", "expose": true, "sample_values": ["family history of breast/ovarian cancer", "not available", "nipple discharge", "no", "family history of breast/ovarian cancer"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "shape", "original_name": "Shape", "type": "string", "description": "", "expose": true, "sample_values": ["irregular", "oval", "oval", "round", "oval"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "margin", "original_name": "Margin", "type": "string", "description": "", "expose": true, "sample_values": ["not circumscribed - indistinct", "not circumscribed - indistinct", "circumscribed", "circumscribed", "circumscribed"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "echogenicity", "original_name": "Echogenicity", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous", "hypoechoic", "hyperechoic", "hypoechoic", "complex cystic/solid"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "posterior_features", "original_name": "Posterior_features", "type": "string", "description": "", "expose": true, "sample_values": ["shadowing", "no", "no", "no", "enhancement"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "halo", "original_name": "Halo", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "calcifications", "original_name": "Calcifications", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "skin_thickening", "original_name": "Skin_thickening", "type": "string", "description": "", "expose": true, "sample_values": ["yes", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "interpretation", "original_name": "Interpretation", "type": "string", "description": "", "expose": true, "sample_values": ["Breast scar (surgery)&Breast scar (radiotherapy)", "Dysplasia&Fibroadenoma", "Duct filled with thick fluid&Intraductal papilloma", "Cyst filled with thick fluid", "Suspicion of malignancy&Intraductal papilloma"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "birads", "original_name": "BIRADS", "type": "string", "description": "", "expose": true, "sample_values": ["2", "4b", "4a", "3", "4b"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "verification", "original_name": "Verification", "type": "string", "description": "", "expose": true, "sample_values": ["confirmed by follow-up care", "confirmed by biopsy", "confirmed by biopsy", "confirmed by follow-up care", "confirmed by biopsy"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "diagnosis", "original_name": "Diagnosis", "type": "string", "description": "", "expose": true, "sample_values": ["not applicable", "Intramammary lymph node", "Usual ductal hyperplasia (UDH)&Pseudoangiomatous stromal hyperplasia (PASH)", "not applicable", "Encapsulated papillary carcinoma&Ductal carcinoma in situ (DCIS)"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "classification", "original_name": "Classification", "type": "string", "description": "", "expose": true, "sample_values": ["benign", "benign", "benign", "benign", "malignant"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}], "dataset_name": "BrEaST-Lesions-USG-clinical-data-Dec-15-2023"}	ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8	256	2026-05-14 23:25:45.977083+01	2026-05-14 23:25:54.974889+01	f	\N	\N	\N	\N	\N	\N	\N
11	4	BrEaST-Lesions-USG-clinical-data-Dec-15-2023	excel	BrEaST-Lesions-USG-clinical-data-Dec-15-2023.xlsx	uploads/42a100c891e04e2f8d1dcdc37949398b.xlsx	active	{"columns": [{"name": "caseid", "original_name": "CaseID", "type": "integer", "description": "", "expose": true, "sample_values": ["1", "2", "3", "4", "5"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "image_filename", "original_name": "Image_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001.png", "case002.png", "case003.png", "case004.png", "case005.png"], "nullable": false, "flag": "url", "flag_color": "badge-ghost", "hint": "URL or image link field.", "confidence": 0.98}, {"name": "mask_tumor_filename", "original_name": "Mask_tumor_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001_tumor.png", "case002_tumor.png", "case003_tumor.png", "case004_tumor.png", "case005_tumor.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "mask_other_filename", "original_name": "Mask_other_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case022_other1.png&case022_other2.png", "case036_other1.png&case036_other2.png", "case038_other1.png", "case085_other1.png&case085_other2.png", "case092_other1.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "pixel_size", "original_name": "Pixel_size", "type": "number", "description": "", "expose": true, "sample_values": ["0.0078125", "0.006462036", "0.006944444", "0.0078125", "0.0078125"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "age", "original_name": "Age", "type": "string", "description": "", "expose": true, "sample_values": ["57", "not available", "56", "43", "67"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "tissue_composition", "original_name": "Tissue_composition", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous: predominantly fat", "homogeneous: fat", "heterogeneous: predominantly fat", "homogeneous: fibroglandular", "homogeneous: fat"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "signs", "original_name": "Signs", "type": "string", "description": "", "expose": true, "sample_values": ["breast scar", "not available", "no", "no", "nipple retraction&palpable"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "symptoms", "original_name": "Symptoms", "type": "string", "description": "", "expose": true, "sample_values": ["family history of breast/ovarian cancer", "not available", "nipple discharge", "no", "family history of breast/ovarian cancer"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "shape", "original_name": "Shape", "type": "string", "description": "", "expose": true, "sample_values": ["irregular", "oval", "oval", "round", "oval"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "margin", "original_name": "Margin", "type": "string", "description": "", "expose": true, "sample_values": ["not circumscribed - indistinct", "not circumscribed - indistinct", "circumscribed", "circumscribed", "circumscribed"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "echogenicity", "original_name": "Echogenicity", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous", "hypoechoic", "hyperechoic", "hypoechoic", "complex cystic/solid"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "posterior_features", "original_name": "Posterior_features", "type": "string", "description": "", "expose": true, "sample_values": ["shadowing", "no", "no", "no", "enhancement"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "halo", "original_name": "Halo", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "calcifications", "original_name": "Calcifications", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "skin_thickening", "original_name": "Skin_thickening", "type": "string", "description": "", "expose": true, "sample_values": ["yes", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "interpretation", "original_name": "Interpretation", "type": "string", "description": "", "expose": true, "sample_values": ["Breast scar (surgery)&Breast scar (radiotherapy)", "Dysplasia&Fibroadenoma", "Duct filled with thick fluid&Intraductal papilloma", "Cyst filled with thick fluid", "Suspicion of malignancy&Intraductal papilloma"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "birads", "original_name": "BIRADS", "type": "string", "description": "", "expose": true, "sample_values": ["2", "4b", "4a", "3", "4b"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "verification", "original_name": "Verification", "type": "string", "description": "", "expose": true, "sample_values": ["confirmed by follow-up care", "confirmed by biopsy", "confirmed by biopsy", "confirmed by follow-up care", "confirmed by biopsy"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "diagnosis", "original_name": "Diagnosis", "type": "string", "description": "", "expose": true, "sample_values": ["not applicable", "Intramammary lymph node", "Usual ductal hyperplasia (UDH)&Pseudoangiomatous stromal hyperplasia (PASH)", "not applicable", "Encapsulated papillary carcinoma&Ductal carcinoma in situ (DCIS)"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "classification", "original_name": "Classification", "type": "string", "description": "", "expose": true, "sample_values": ["benign", "benign", "benign", "benign", "malignant"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}], "row_count": 256, "sheet_count": 1, "data_preview": [{"CaseID": "1", "Image_filename": "case001.png", "Mask_tumor_filename": "case001_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.0078125", "Age": "57", "Tissue_composition": "heterogeneous: predominantly fat", "Signs": "breast scar", "Symptoms": "family history of breast/ovarian cancer", "Shape": "irregular", "Margin": "not circumscribed - indistinct", "Echogenicity": "heterogeneous", "Posterior_features": "shadowing", "Halo": "no", "Calcifications": "no", "Skin_thickening": "yes", "Interpretation": "Breast scar (surgery)&Breast scar (radiotherapy)", "BIRADS": "2", "Verification": "confirmed by follow-up care", "Diagnosis": "not applicable", "Classification": "benign"}, {"CaseID": "2", "Image_filename": "case002.png", "Mask_tumor_filename": "case002_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.006462036", "Age": "not available", "Tissue_composition": "homogeneous: fat", "Signs": "not available", "Symptoms": "not available", "Shape": "oval", "Margin": "not circumscribed - indistinct", "Echogenicity": "hypoechoic", "Posterior_features": "no", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Dysplasia&Fibroadenoma", "BIRADS": "4b", "Verification": "confirmed by biopsy", "Diagnosis": "Intramammary lymph node", "Classification": "benign"}, {"CaseID": "3", "Image_filename": "case003.png", "Mask_tumor_filename": "case003_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.006944444", "Age": "56", "Tissue_composition": "heterogeneous: predominantly fat", "Signs": "no", "Symptoms": "nipple discharge", "Shape": "oval", "Margin": "circumscribed", "Echogenicity": "hyperechoic", "Posterior_features": "no", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Duct filled with thick fluid&Intraductal papilloma", "BIRADS": "4a", "Verification": "confirmed by biopsy", "Diagnosis": "Usual ductal hyperplasia (UDH)&Pseudoangiomatous stromal hyperplasia (PASH)", "Classification": "benign"}, {"CaseID": "4", "Image_filename": "case004.png", "Mask_tumor_filename": "case004_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.0078125", "Age": "43", "Tissue_composition": "homogeneous: fibroglandular", "Signs": "no", "Symptoms": "no", "Shape": "round", "Margin": "circumscribed", "Echogenicity": "hypoechoic", "Posterior_features": "no", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Cyst filled with thick fluid", "BIRADS": "3", "Verification": "confirmed by follow-up care", "Diagnosis": "not applicable", "Classification": "benign"}, {"CaseID": "5", "Image_filename": "case005.png", "Mask_tumor_filename": "case005_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.0078125", "Age": "67", "Tissue_composition": "homogeneous: fat", "Signs": "nipple retraction&palpable", "Symptoms": "family history of breast/ovarian cancer", "Shape": "oval", "Margin": "circumscribed", "Echogenicity": "complex cystic/solid", "Posterior_features": "enhancement", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Suspicion of malignancy&Intraductal papilloma", "BIRADS": "4b", "Verification": "confirmed by biopsy", "Diagnosis": "Encapsulated papillary carcinoma&Ductal carcinoma in situ (DCIS)", "Classification": "malignant"}], "ai_mode": "editor", "confidence": 0.63}	{"columns": [{"name": "caseid", "original_name": "CaseID", "type": "integer", "description": "", "expose": true, "sample_values": ["1", "2", "3", "4", "5"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "image_filename", "original_name": "Image_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001.png", "case002.png", "case003.png", "case004.png", "case005.png"], "nullable": false, "flag": "url", "flag_color": "badge-ghost", "hint": "URL or image link field.", "confidence": 0.98}, {"name": "mask_tumor_filename", "original_name": "Mask_tumor_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001_tumor.png", "case002_tumor.png", "case003_tumor.png", "case004_tumor.png", "case005_tumor.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "mask_other_filename", "original_name": "Mask_other_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case022_other1.png&case022_other2.png", "case036_other1.png&case036_other2.png", "case038_other1.png", "case085_other1.png&case085_other2.png", "case092_other1.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "pixel_size", "original_name": "Pixel_size", "type": "number", "description": "", "expose": true, "sample_values": ["0.0078125", "0.006462036", "0.006944444", "0.0078125", "0.0078125"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "age", "original_name": "Age", "type": "string", "description": "", "expose": true, "sample_values": ["57", "not available", "56", "43", "67"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "tissue_composition", "original_name": "Tissue_composition", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous: predominantly fat", "homogeneous: fat", "heterogeneous: predominantly fat", "homogeneous: fibroglandular", "homogeneous: fat"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "signs", "original_name": "Signs", "type": "string", "description": "", "expose": true, "sample_values": ["breast scar", "not available", "no", "no", "nipple retraction&palpable"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "symptoms", "original_name": "Symptoms", "type": "string", "description": "", "expose": true, "sample_values": ["family history of breast/ovarian cancer", "not available", "nipple discharge", "no", "family history of breast/ovarian cancer"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "shape", "original_name": "Shape", "type": "string", "description": "", "expose": true, "sample_values": ["irregular", "oval", "oval", "round", "oval"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "margin", "original_name": "Margin", "type": "string", "description": "", "expose": true, "sample_values": ["not circumscribed - indistinct", "not circumscribed - indistinct", "circumscribed", "circumscribed", "circumscribed"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "echogenicity", "original_name": "Echogenicity", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous", "hypoechoic", "hyperechoic", "hypoechoic", "complex cystic/solid"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "posterior_features", "original_name": "Posterior_features", "type": "string", "description": "", "expose": true, "sample_values": ["shadowing", "no", "no", "no", "enhancement"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "halo", "original_name": "Halo", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "calcifications", "original_name": "Calcifications", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "skin_thickening", "original_name": "Skin_thickening", "type": "string", "description": "", "expose": true, "sample_values": ["yes", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "interpretation", "original_name": "Interpretation", "type": "string", "description": "", "expose": true, "sample_values": ["Breast scar (surgery)&Breast scar (radiotherapy)", "Dysplasia&Fibroadenoma", "Duct filled with thick fluid&Intraductal papilloma", "Cyst filled with thick fluid", "Suspicion of malignancy&Intraductal papilloma"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "birads", "original_name": "BIRADS", "type": "string", "description": "", "expose": true, "sample_values": ["2", "4b", "4a", "3", "4b"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "verification", "original_name": "Verification", "type": "string", "description": "", "expose": true, "sample_values": ["confirmed by follow-up care", "confirmed by biopsy", "confirmed by biopsy", "confirmed by follow-up care", "confirmed by biopsy"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "diagnosis", "original_name": "Diagnosis", "type": "string", "description": "", "expose": true, "sample_values": ["not applicable", "Intramammary lymph node", "Usual ductal hyperplasia (UDH)&Pseudoangiomatous stromal hyperplasia (PASH)", "not applicable", "Encapsulated papillary carcinoma&Ductal carcinoma in situ (DCIS)"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "classification", "original_name": "Classification", "type": "string", "description": "", "expose": true, "sample_values": ["benign", "benign", "benign", "benign", "malignant"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}], "dataset_name": "BrEaST-Lesions-USG-clinical-data-Dec-15-2023"}	ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1	256	2026-05-14 23:30:24.51159+01	2026-05-14 23:30:51.743352+01	f	\N	\N	\N	\N	\N	\N	\N
12	1	Test	excel	BrEaST-Lesions-USG-clinical-data-Dec-15-2023.xlsx	uploads/b18711a057d049c6a8eef9c77e568bf9.xlsx	active	{"columns": [{"name": "caseid", "original_name": "CaseID", "type": "integer", "description": "", "expose": true, "sample_values": ["1", "2", "3", "4", "5"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "image_filename", "original_name": "Image_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001.png", "case002.png", "case003.png", "case004.png", "case005.png"], "nullable": false, "flag": "url", "flag_color": "badge-ghost", "hint": "URL or image link field.", "confidence": 0.98}, {"name": "mask_tumor_filename", "original_name": "Mask_tumor_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001_tumor.png", "case002_tumor.png", "case003_tumor.png", "case004_tumor.png", "case005_tumor.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "mask_other_filename", "original_name": "Mask_other_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case022_other1.png&case022_other2.png", "case036_other1.png&case036_other2.png", "case038_other1.png", "case085_other1.png&case085_other2.png", "case092_other1.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "pixel_size", "original_name": "Pixel_size", "type": "number", "description": "", "expose": true, "sample_values": ["0.0078125", "0.006462036", "0.006944444", "0.0078125", "0.0078125"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "age", "original_name": "Age", "type": "string", "description": "", "expose": true, "sample_values": ["57", "not available", "56", "43", "67"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "tissue_composition", "original_name": "Tissue_composition", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous: predominantly fat", "homogeneous: fat", "heterogeneous: predominantly fat", "homogeneous: fibroglandular", "homogeneous: fat"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "signs", "original_name": "Signs", "type": "string", "description": "", "expose": true, "sample_values": ["breast scar", "not available", "no", "no", "nipple retraction&palpable"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "symptoms", "original_name": "Symptoms", "type": "string", "description": "", "expose": true, "sample_values": ["family history of breast/ovarian cancer", "not available", "nipple discharge", "no", "family history of breast/ovarian cancer"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "shape", "original_name": "Shape", "type": "string", "description": "", "expose": true, "sample_values": ["irregular", "oval", "oval", "round", "oval"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "margin", "original_name": "Margin", "type": "string", "description": "", "expose": true, "sample_values": ["not circumscribed - indistinct", "not circumscribed - indistinct", "circumscribed", "circumscribed", "circumscribed"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "echogenicity", "original_name": "Echogenicity", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous", "hypoechoic", "hyperechoic", "hypoechoic", "complex cystic/solid"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "posterior_features", "original_name": "Posterior_features", "type": "string", "description": "", "expose": true, "sample_values": ["shadowing", "no", "no", "no", "enhancement"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "halo", "original_name": "Halo", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "calcifications", "original_name": "Calcifications", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "skin_thickening", "original_name": "Skin_thickening", "type": "string", "description": "", "expose": true, "sample_values": ["yes", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "interpretation", "original_name": "Interpretation", "type": "string", "description": "", "expose": true, "sample_values": ["Breast scar (surgery)&Breast scar (radiotherapy)", "Dysplasia&Fibroadenoma", "Duct filled with thick fluid&Intraductal papilloma", "Cyst filled with thick fluid", "Suspicion of malignancy&Intraductal papilloma"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "birads", "original_name": "BIRADS", "type": "string", "description": "", "expose": true, "sample_values": ["2", "4b", "4a", "3", "4b"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "verification", "original_name": "Verification", "type": "string", "description": "", "expose": true, "sample_values": ["confirmed by follow-up care", "confirmed by biopsy", "confirmed by biopsy", "confirmed by follow-up care", "confirmed by biopsy"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "diagnosis", "original_name": "Diagnosis", "type": "string", "description": "", "expose": true, "sample_values": ["not applicable", "Intramammary lymph node", "Usual ductal hyperplasia (UDH)&Pseudoangiomatous stromal hyperplasia (PASH)", "not applicable", "Encapsulated papillary carcinoma&Ductal carcinoma in situ (DCIS)"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "classification", "original_name": "Classification", "type": "string", "description": "", "expose": true, "sample_values": ["benign", "benign", "benign", "benign", "malignant"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}], "row_count": 256, "sheet_count": 1, "data_preview": [{"CaseID": "1", "Image_filename": "case001.png", "Mask_tumor_filename": "case001_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.0078125", "Age": "57", "Tissue_composition": "heterogeneous: predominantly fat", "Signs": "breast scar", "Symptoms": "family history of breast/ovarian cancer", "Shape": "irregular", "Margin": "not circumscribed - indistinct", "Echogenicity": "heterogeneous", "Posterior_features": "shadowing", "Halo": "no", "Calcifications": "no", "Skin_thickening": "yes", "Interpretation": "Breast scar (surgery)&Breast scar (radiotherapy)", "BIRADS": "2", "Verification": "confirmed by follow-up care", "Diagnosis": "not applicable", "Classification": "benign"}, {"CaseID": "2", "Image_filename": "case002.png", "Mask_tumor_filename": "case002_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.006462036", "Age": "not available", "Tissue_composition": "homogeneous: fat", "Signs": "not available", "Symptoms": "not available", "Shape": "oval", "Margin": "not circumscribed - indistinct", "Echogenicity": "hypoechoic", "Posterior_features": "no", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Dysplasia&Fibroadenoma", "BIRADS": "4b", "Verification": "confirmed by biopsy", "Diagnosis": "Intramammary lymph node", "Classification": "benign"}, {"CaseID": "3", "Image_filename": "case003.png", "Mask_tumor_filename": "case003_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.006944444", "Age": "56", "Tissue_composition": "heterogeneous: predominantly fat", "Signs": "no", "Symptoms": "nipple discharge", "Shape": "oval", "Margin": "circumscribed", "Echogenicity": "hyperechoic", "Posterior_features": "no", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Duct filled with thick fluid&Intraductal papilloma", "BIRADS": "4a", "Verification": "confirmed by biopsy", "Diagnosis": "Usual ductal hyperplasia (UDH)&Pseudoangiomatous stromal hyperplasia (PASH)", "Classification": "benign"}, {"CaseID": "4", "Image_filename": "case004.png", "Mask_tumor_filename": "case004_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.0078125", "Age": "43", "Tissue_composition": "homogeneous: fibroglandular", "Signs": "no", "Symptoms": "no", "Shape": "round", "Margin": "circumscribed", "Echogenicity": "hypoechoic", "Posterior_features": "no", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Cyst filled with thick fluid", "BIRADS": "3", "Verification": "confirmed by follow-up care", "Diagnosis": "not applicable", "Classification": "benign"}, {"CaseID": "5", "Image_filename": "case005.png", "Mask_tumor_filename": "case005_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.0078125", "Age": "67", "Tissue_composition": "homogeneous: fat", "Signs": "nipple retraction&palpable", "Symptoms": "family history of breast/ovarian cancer", "Shape": "oval", "Margin": "circumscribed", "Echogenicity": "complex cystic/solid", "Posterior_features": "enhancement", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Suspicion of malignancy&Intraductal papilloma", "BIRADS": "4b", "Verification": "confirmed by biopsy", "Diagnosis": "Encapsulated papillary carcinoma&Ductal carcinoma in situ (DCIS)", "Classification": "malignant"}], "ai_mode": "editor", "confidence": 0.63}	{"columns": [{"name": "caseid", "original_name": "CaseID", "type": "integer", "description": "", "expose": true, "sample_values": ["1", "2", "3", "4", "5"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "image_filename", "original_name": "Image_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001.png", "case002.png", "case003.png", "case004.png", "case005.png"], "nullable": false, "flag": "url", "flag_color": "badge-ghost", "hint": "URL or image link field.", "confidence": 0.98}, {"name": "mask_tumor_filename", "original_name": "Mask_tumor_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001_tumor.png", "case002_tumor.png", "case003_tumor.png", "case004_tumor.png", "case005_tumor.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "mask_other_filename", "original_name": "Mask_other_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case022_other1.png&case022_other2.png", "case036_other1.png&case036_other2.png", "case038_other1.png", "case085_other1.png&case085_other2.png", "case092_other1.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "pixel_size", "original_name": "Pixel_size", "type": "number", "description": "", "expose": true, "sample_values": ["0.0078125", "0.006462036", "0.006944444", "0.0078125", "0.0078125"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "age", "original_name": "Age", "type": "string", "description": "", "expose": true, "sample_values": ["57", "not available", "56", "43", "67"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "tissue_composition", "original_name": "Tissue_composition", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous: predominantly fat", "homogeneous: fat", "heterogeneous: predominantly fat", "homogeneous: fibroglandular", "homogeneous: fat"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "signs", "original_name": "Signs", "type": "string", "description": "", "expose": true, "sample_values": ["breast scar", "not available", "no", "no", "nipple retraction&palpable"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "symptoms", "original_name": "Symptoms", "type": "string", "description": "", "expose": true, "sample_values": ["family history of breast/ovarian cancer", "not available", "nipple discharge", "no", "family history of breast/ovarian cancer"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "shape", "original_name": "Shape", "type": "string", "description": "", "expose": true, "sample_values": ["irregular", "oval", "oval", "round", "oval"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "margin", "original_name": "Margin", "type": "string", "description": "", "expose": true, "sample_values": ["not circumscribed - indistinct", "not circumscribed - indistinct", "circumscribed", "circumscribed", "circumscribed"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "echogenicity", "original_name": "Echogenicity", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous", "hypoechoic", "hyperechoic", "hypoechoic", "complex cystic/solid"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "posterior_features", "original_name": "Posterior_features", "type": "string", "description": "", "expose": true, "sample_values": ["shadowing", "no", "no", "no", "enhancement"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "halo", "original_name": "Halo", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "calcifications", "original_name": "Calcifications", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "skin_thickening", "original_name": "Skin_thickening", "type": "string", "description": "", "expose": true, "sample_values": ["yes", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "interpretation", "original_name": "Interpretation", "type": "string", "description": "", "expose": true, "sample_values": ["Breast scar (surgery)&Breast scar (radiotherapy)", "Dysplasia&Fibroadenoma", "Duct filled with thick fluid&Intraductal papilloma", "Cyst filled with thick fluid", "Suspicion of malignancy&Intraductal papilloma"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "birads", "original_name": "BIRADS", "type": "string", "description": "", "expose": true, "sample_values": ["2", "4b", "4a", "3", "4b"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "verification", "original_name": "Verification", "type": "string", "description": "", "expose": true, "sample_values": ["confirmed by follow-up care", "confirmed by biopsy", "confirmed by biopsy", "confirmed by follow-up care", "confirmed by biopsy"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "diagnosis", "original_name": "Diagnosis", "type": "string", "description": "", "expose": true, "sample_values": ["not applicable", "Intramammary lymph node", "Usual ductal hyperplasia (UDH)&Pseudoangiomatous stromal hyperplasia (PASH)", "not applicable", "Encapsulated papillary carcinoma&Ductal carcinoma in situ (DCIS)"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "classification", "original_name": "Classification", "type": "string", "description": "", "expose": true, "sample_values": ["benign", "benign", "benign", "benign", "malignant"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}], "dataset_name": "Test"}	ds_1_test_74ec9ab8	256	2026-05-14 23:36:16.31761+01	2026-05-14 23:36:41.53088+01	f	\N	\N	\N	\N	\N	\N	\N
13	3	Breast dataset	excel	BrEaST-Lesions-USG-clinical-data-Dec-15-2023.xlsx	uploads/c587f8e10b2d49edafd13fd8ea3e7443.xlsx	active	{"columns": [{"name": "caseid", "original_name": "CaseID", "type": "integer", "description": "", "expose": true, "sample_values": ["1", "2", "3", "4", "5"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "image_filename", "original_name": "Image_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001.png", "case002.png", "case003.png", "case004.png", "case005.png"], "nullable": false, "flag": "url", "flag_color": "badge-ghost", "hint": "URL or image link field.", "confidence": 0.98}, {"name": "mask_tumor_filename", "original_name": "Mask_tumor_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001_tumor.png", "case002_tumor.png", "case003_tumor.png", "case004_tumor.png", "case005_tumor.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "mask_other_filename", "original_name": "Mask_other_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case022_other1.png&case022_other2.png", "case036_other1.png&case036_other2.png", "case038_other1.png", "case085_other1.png&case085_other2.png", "case092_other1.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "pixel_size", "original_name": "Pixel_size", "type": "number", "description": "", "expose": true, "sample_values": ["0.0078125", "0.006462036", "0.006944444", "0.0078125", "0.0078125"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "age", "original_name": "Age", "type": "string", "description": "", "expose": true, "sample_values": ["57", "not available", "56", "43", "67"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "tissue_composition", "original_name": "Tissue_composition", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous: predominantly fat", "homogeneous: fat", "heterogeneous: predominantly fat", "homogeneous: fibroglandular", "homogeneous: fat"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "signs", "original_name": "Signs", "type": "string", "description": "", "expose": true, "sample_values": ["breast scar", "not available", "no", "no", "nipple retraction&palpable"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "symptoms", "original_name": "Symptoms", "type": "string", "description": "", "expose": true, "sample_values": ["family history of breast/ovarian cancer", "not available", "nipple discharge", "no", "family history of breast/ovarian cancer"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "shape", "original_name": "Shape", "type": "string", "description": "", "expose": true, "sample_values": ["irregular", "oval", "oval", "round", "oval"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "margin", "original_name": "Margin", "type": "string", "description": "", "expose": true, "sample_values": ["not circumscribed - indistinct", "not circumscribed - indistinct", "circumscribed", "circumscribed", "circumscribed"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "echogenicity", "original_name": "Echogenicity", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous", "hypoechoic", "hyperechoic", "hypoechoic", "complex cystic/solid"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "posterior_features", "original_name": "Posterior_features", "type": "string", "description": "", "expose": true, "sample_values": ["shadowing", "no", "no", "no", "enhancement"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "halo", "original_name": "Halo", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "calcifications", "original_name": "Calcifications", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "skin_thickening", "original_name": "Skin_thickening", "type": "string", "description": "", "expose": true, "sample_values": ["yes", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "interpretation", "original_name": "Interpretation", "type": "string", "description": "", "expose": true, "sample_values": ["Breast scar (surgery)&Breast scar (radiotherapy)", "Dysplasia&Fibroadenoma", "Duct filled with thick fluid&Intraductal papilloma", "Cyst filled with thick fluid", "Suspicion of malignancy&Intraductal papilloma"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "birads", "original_name": "BIRADS", "type": "string", "description": "", "expose": true, "sample_values": ["2", "4b", "4a", "3", "4b"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "verification", "original_name": "Verification", "type": "string", "description": "", "expose": true, "sample_values": ["confirmed by follow-up care", "confirmed by biopsy", "confirmed by biopsy", "confirmed by follow-up care", "confirmed by biopsy"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "diagnosis", "original_name": "Diagnosis", "type": "string", "description": "", "expose": true, "sample_values": ["not applicable", "Intramammary lymph node", "Usual ductal hyperplasia (UDH)&Pseudoangiomatous stromal hyperplasia (PASH)", "not applicable", "Encapsulated papillary carcinoma&Ductal carcinoma in situ (DCIS)"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "classification", "original_name": "Classification", "type": "string", "description": "", "expose": true, "sample_values": ["benign", "benign", "benign", "benign", "malignant"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}], "row_count": 256, "sheet_count": 1, "data_preview": [{"CaseID": "1", "Image_filename": "case001.png", "Mask_tumor_filename": "case001_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.0078125", "Age": "57", "Tissue_composition": "heterogeneous: predominantly fat", "Signs": "breast scar", "Symptoms": "family history of breast/ovarian cancer", "Shape": "irregular", "Margin": "not circumscribed - indistinct", "Echogenicity": "heterogeneous", "Posterior_features": "shadowing", "Halo": "no", "Calcifications": "no", "Skin_thickening": "yes", "Interpretation": "Breast scar (surgery)&Breast scar (radiotherapy)", "BIRADS": "2", "Verification": "confirmed by follow-up care", "Diagnosis": "not applicable", "Classification": "benign"}, {"CaseID": "2", "Image_filename": "case002.png", "Mask_tumor_filename": "case002_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.006462036", "Age": "not available", "Tissue_composition": "homogeneous: fat", "Signs": "not available", "Symptoms": "not available", "Shape": "oval", "Margin": "not circumscribed - indistinct", "Echogenicity": "hypoechoic", "Posterior_features": "no", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Dysplasia&Fibroadenoma", "BIRADS": "4b", "Verification": "confirmed by biopsy", "Diagnosis": "Intramammary lymph node", "Classification": "benign"}, {"CaseID": "3", "Image_filename": "case003.png", "Mask_tumor_filename": "case003_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.006944444", "Age": "56", "Tissue_composition": "heterogeneous: predominantly fat", "Signs": "no", "Symptoms": "nipple discharge", "Shape": "oval", "Margin": "circumscribed", "Echogenicity": "hyperechoic", "Posterior_features": "no", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Duct filled with thick fluid&Intraductal papilloma", "BIRADS": "4a", "Verification": "confirmed by biopsy", "Diagnosis": "Usual ductal hyperplasia (UDH)&Pseudoangiomatous stromal hyperplasia (PASH)", "Classification": "benign"}, {"CaseID": "4", "Image_filename": "case004.png", "Mask_tumor_filename": "case004_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.0078125", "Age": "43", "Tissue_composition": "homogeneous: fibroglandular", "Signs": "no", "Symptoms": "no", "Shape": "round", "Margin": "circumscribed", "Echogenicity": "hypoechoic", "Posterior_features": "no", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Cyst filled with thick fluid", "BIRADS": "3", "Verification": "confirmed by follow-up care", "Diagnosis": "not applicable", "Classification": "benign"}, {"CaseID": "5", "Image_filename": "case005.png", "Mask_tumor_filename": "case005_tumor.png", "Mask_other_filename": "", "Pixel_size": "0.0078125", "Age": "67", "Tissue_composition": "homogeneous: fat", "Signs": "nipple retraction&palpable", "Symptoms": "family history of breast/ovarian cancer", "Shape": "oval", "Margin": "circumscribed", "Echogenicity": "complex cystic/solid", "Posterior_features": "enhancement", "Halo": "no", "Calcifications": "no", "Skin_thickening": "no", "Interpretation": "Suspicion of malignancy&Intraductal papilloma", "BIRADS": "4b", "Verification": "confirmed by biopsy", "Diagnosis": "Encapsulated papillary carcinoma&Ductal carcinoma in situ (DCIS)", "Classification": "malignant"}], "ai_mode": "editor", "confidence": 0.63}	{"columns": [{"name": "caseid", "original_name": "CaseID", "type": "integer", "description": "", "expose": true, "sample_values": ["1", "2", "3", "4", "5"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "image_filename", "original_name": "Image_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001.png", "case002.png", "case003.png", "case004.png", "case005.png"], "nullable": false, "flag": "url", "flag_color": "badge-ghost", "hint": "URL or image link field.", "confidence": 0.98}, {"name": "mask_tumor_filename", "original_name": "Mask_tumor_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case001_tumor.png", "case002_tumor.png", "case003_tumor.png", "case004_tumor.png", "case005_tumor.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "mask_other_filename", "original_name": "Mask_other_filename", "type": "string", "description": "", "expose": true, "sample_values": ["case022_other1.png&case022_other2.png", "case036_other1.png&case036_other2.png", "case038_other1.png", "case085_other1.png&case085_other2.png", "case092_other1.png"], "nullable": true, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "pixel_size", "original_name": "Pixel_size", "type": "number", "description": "", "expose": true, "sample_values": ["0.0078125", "0.006462036", "0.006944444", "0.0078125", "0.0078125"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "age", "original_name": "Age", "type": "string", "description": "", "expose": true, "sample_values": ["57", "not available", "56", "43", "67"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "tissue_composition", "original_name": "Tissue_composition", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous: predominantly fat", "homogeneous: fat", "heterogeneous: predominantly fat", "homogeneous: fibroglandular", "homogeneous: fat"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "signs", "original_name": "Signs", "type": "string", "description": "", "expose": true, "sample_values": ["breast scar", "not available", "no", "no", "nipple retraction&palpable"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "symptoms", "original_name": "Symptoms", "type": "string", "description": "", "expose": true, "sample_values": ["family history of breast/ovarian cancer", "not available", "nipple discharge", "no", "family history of breast/ovarian cancer"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "shape", "original_name": "Shape", "type": "string", "description": "", "expose": true, "sample_values": ["irregular", "oval", "oval", "round", "oval"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "margin", "original_name": "Margin", "type": "string", "description": "", "expose": true, "sample_values": ["not circumscribed - indistinct", "not circumscribed - indistinct", "circumscribed", "circumscribed", "circumscribed"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "echogenicity", "original_name": "Echogenicity", "type": "string", "description": "", "expose": true, "sample_values": ["heterogeneous", "hypoechoic", "hyperechoic", "hypoechoic", "complex cystic/solid"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "posterior_features", "original_name": "Posterior_features", "type": "string", "description": "", "expose": true, "sample_values": ["shadowing", "no", "no", "no", "enhancement"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "halo", "original_name": "Halo", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "calcifications", "original_name": "Calcifications", "type": "string", "description": "", "expose": true, "sample_values": ["no", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "skin_thickening", "original_name": "Skin_thickening", "type": "string", "description": "", "expose": true, "sample_values": ["yes", "no", "no", "no", "no"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "interpretation", "original_name": "Interpretation", "type": "string", "description": "", "expose": true, "sample_values": ["Breast scar (surgery)&Breast scar (radiotherapy)", "Dysplasia&Fibroadenoma", "Duct filled with thick fluid&Intraductal papilloma", "Cyst filled with thick fluid", "Suspicion of malignancy&Intraductal papilloma"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "birads", "original_name": "BIRADS", "type": "string", "description": "", "expose": true, "sample_values": ["2", "4b", "4a", "3", "4b"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "verification", "original_name": "Verification", "type": "string", "description": "", "expose": true, "sample_values": ["confirmed by follow-up care", "confirmed by biopsy", "confirmed by biopsy", "confirmed by follow-up care", "confirmed by biopsy"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "diagnosis", "original_name": "Diagnosis", "type": "string", "description": "", "expose": true, "sample_values": ["not applicable", "Intramammary lymph node", "Usual ductal hyperplasia (UDH)&Pseudoangiomatous stromal hyperplasia (PASH)", "not applicable", "Encapsulated papillary carcinoma&Ductal carcinoma in situ (DCIS)"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}, {"name": "classification", "original_name": "Classification", "type": "string", "description": "", "expose": true, "sample_values": ["benign", "benign", "benign", "benign", "malignant"], "nullable": false, "flag": "", "flag_color": "badge-ghost", "hint": "", "confidence": 0.63}], "dataset_name": "Breast dataset"}	ds_3_breast_dataset_c6c9cc35	256	2026-05-26 00:10:02.926906+01	2026-05-26 00:10:08.863732+01	f	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: ds_1_employees_seed; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ds_1_employees_seed (id, employee_id, full_name, department, role, hire_date, location) FROM stdin;
1	EMP-100	Liam Davis	Finance	Senior Engineer	2024-08-16	San Francisco
2	EMP-101	Emma Wilson	HR	Analyst	2025-08-24	Chicago
3	EMP-102	Zoe Thompson	Engineering	Manager	2023-03-06	London
4	EMP-103	Liam Davis	Design	Director	2024-12-27	San Francisco
5	EMP-104	Isabella Chen	Marketing	Senior Engineer	2022-02-21	Remote
6	EMP-105	Oliver Martinez	Sales	Designer	2024-03-13	London
7	EMP-106	Noah Williams	HR	Manager	2024-04-02	Remote
8	EMP-107	Maya Patel	Finance	Manager	2024-10-11	Austin
9	EMP-108	Liam Davis	Finance	Director	2023-03-10	San Francisco
10	EMP-109	Isabella Chen	Finance	Manager	2021-07-24	Remote
11	EMP-110	Noah Williams	Sales	Manager	2026-02-04	New York
12	EMP-111	Ava Rodriguez	Design	Analyst	2021-05-30	Chicago
13	EMP-112	Emma Wilson	HR	Manager	2025-05-24	San Francisco
14	EMP-113	Oliver Martinez	Operations	Associate	2022-02-27	New York
15	EMP-114	Emma Wilson	Design	Analyst	2023-10-29	Austin
16	EMP-115	Oliver Martinez	Marketing	Manager	2026-04-03	San Francisco
17	EMP-116	Isabella Chen	HR	Senior Engineer	2021-06-12	Remote
18	EMP-117	Isabella Chen	Sales	Director	2021-10-24	London
19	EMP-118	Ava Rodriguez	Engineering	Analyst	2023-07-22	London
20	EMP-119	Isabella Chen	Finance	Analyst	2024-08-24	New York
21	EMP-120	Liam Davis	Sales	Manager	2024-12-12	Austin
22	EMP-121	Lucas Fernandez	Operations	Senior Engineer	2023-08-18	Remote
23	EMP-122	Ethan Brooks	Engineering	Associate	2024-03-10	London
24	EMP-123	James Carter	Sales	Associate	2023-11-28	London
25	EMP-124	Ethan Brooks	Finance	Associate	2025-12-21	New York
26	EMP-125	Emma Wilson	Engineering	Designer	2025-05-27	Chicago
27	EMP-126	James Carter	HR	Designer	2025-05-31	Remote
28	EMP-127	Ava Rodriguez	Finance	Senior Engineer	2024-08-24	New York
29	EMP-128	Ethan Brooks	Marketing	Senior Engineer	2024-09-08	Remote
30	EMP-129	Isabella Chen	Operations	Manager	2025-09-22	Austin
31	EMP-130	Isabella Chen	Engineering	Associate	2023-07-16	Austin
32	EMP-131	Noah Williams	HR	Senior Engineer	2025-03-13	London
33	EMP-132	Sophia Kim	Design	Designer	2024-11-24	Remote
34	EMP-133	Lucas Fernandez	Sales	Director	2023-06-13	Austin
35	EMP-134	Maya Patel	Marketing	Senior Engineer	2026-03-24	Austin
36	EMP-135	Emma Wilson	Engineering	Manager	2025-01-27	San Francisco
37	EMP-136	Maya Patel	Operations	Senior Engineer	2025-07-29	San Francisco
38	EMP-137	Lucas Fernandez	Sales	Director	2025-01-01	New York
39	EMP-138	Isabella Chen	Marketing	Senior Engineer	2023-03-27	London
40	EMP-139	James Carter	Engineering	Analyst	2021-08-10	London
41	EMP-140	James Carter	HR	Manager	2026-01-09	Remote
42	EMP-141	Lucas Fernandez	Engineering	Manager	2025-07-20	San Francisco
43	EMP-142	Sophia Kim	HR	Senior Engineer	2026-03-20	Austin
44	EMP-143	Isabella Chen	HR	Senior Engineer	2026-01-11	Remote
45	EMP-144	Emma Wilson	Sales	Manager	2022-04-15	New York
46	EMP-145	Sophia Kim	Sales	Manager	2022-05-31	London
47	EMP-146	Noah Williams	Marketing	Director	2021-12-25	London
48	EMP-147	Isabella Chen	Sales	Director	2024-10-14	New York
49	EMP-148	Isabella Chen	Marketing	Analyst	2025-01-19	New York
50	EMP-149	Ethan Brooks	Sales	Associate	2024-02-05	London
51	EMP-150	Isabella Chen	Sales	Senior Engineer	2025-06-25	Chicago
52	EMP-151	Isabella Chen	Sales	Senior Engineer	2024-05-26	London
53	EMP-152	Noah Williams	HR	Analyst	2024-04-16	San Francisco
54	EMP-153	Oliver Martinez	Design	Manager	2023-02-23	Austin
55	EMP-154	Ethan Brooks	Sales	Associate	2021-07-31	Remote
56	EMP-155	Ava Rodriguez	Marketing	Designer	2023-08-11	New York
57	EMP-156	Sophia Kim	Sales	Analyst	2024-04-01	Austin
58	EMP-157	Ava Rodriguez	Finance	Director	2023-12-17	San Francisco
59	EMP-158	Ethan Brooks	Operations	Designer	2023-02-19	Chicago
60	EMP-159	Lucas Fernandez	Engineering	Associate	2023-04-16	London
\.


--
-- Data for Name: ds_1_invoices_seed; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ds_1_invoices_seed (id, invoice_id, customer_name, amount, status, issue_date, due_date) FROM stdin;
1	INV-1000	Swift Analytics	10047.49	paid	2026-03-25	2026-06-08
2	INV-1001	Swift Analytics	7586.27	paid	2026-03-01	2026-05-20
3	INV-1002	Nova Systems	4290.53	paid	2026-03-29	2026-04-04
4	INV-1003	Atlas Ventures	480.87	paid	2026-03-01	2026-04-12
5	INV-1004	Cedar Group	8835.89	overdue	2026-04-01	2026-03-19
6	INV-1005	Peak Solutions	2618	pending	2026-03-31	2026-05-01
7	INV-1006	Orbit Digital	4096.63	overdue	2026-05-01	2026-04-15
8	INV-1007	Cedar Group	7511.7	paid	2026-04-13	2026-04-07
9	INV-1008	TechWave Ltd	3645.19	paid	2026-03-23	2026-03-30
10	INV-1009	Peak Solutions	195.51	paid	2026-03-30	2026-06-03
11	INV-1010	Cedar Group	5211.43	paid	2026-04-29	2026-04-19
12	INV-1011	Bright Minds Co	11833.6	paid	2026-02-16	2026-04-19
13	INV-1012	TechWave Ltd	7829.91	overdue	2026-05-01	2026-03-21
14	INV-1013	Nova Systems	4293.11	paid	2026-03-14	2026-04-30
15	INV-1014	Blue Sky Inc	6025.22	paid	2026-02-24	2026-06-08
16	INV-1015	Cedar Group	743.11	paid	2026-05-06	2026-04-08
17	INV-1016	Atlas Ventures	936.38	paid	2026-05-08	2026-05-24
18	INV-1017	Acme Corp	1264	paid	2026-04-18	2026-06-12
19	INV-1018	Cedar Group	1151.55	paid	2026-04-23	2026-05-12
20	INV-1019	Swift Analytics	8249.81	paid	2026-03-17	2026-06-10
21	INV-1020	Nova Systems	8802.89	pending	2026-03-27	2026-03-21
22	INV-1021	Nova Systems	8863.71	paid	2026-02-19	2026-05-16
23	INV-1022	Atlas Ventures	10914.23	paid	2026-04-16	2026-05-14
24	INV-1023	Peak Solutions	2206.53	pending	2026-04-26	2026-03-15
25	INV-1024	Atlas Ventures	11143.42	pending	2026-04-21	2026-03-29
26	INV-1025	Orbit Digital	3851.78	pending	2026-03-26	2026-05-17
27	INV-1026	Cedar Group	4943.49	overdue	2026-04-02	2026-05-01
28	INV-1027	Cedar Group	11121.63	paid	2026-02-21	2026-05-26
29	INV-1028	Blue Sky Inc	5499.6	paid	2026-05-04	2026-04-03
30	INV-1029	Atlas Ventures	10643.77	pending	2026-02-25	2026-05-01
31	INV-1030	Cedar Group	3664.27	overdue	2026-03-18	2026-04-01
32	INV-1031	Acme Corp	9446.32	pending	2026-02-18	2026-04-26
33	INV-1032	TechWave Ltd	5459.16	overdue	2026-03-16	2026-05-06
34	INV-1033	Acme Corp	9723.97	pending	2026-03-29	2026-04-08
35	INV-1034	Bright Minds Co	8668.44	paid	2026-02-13	2026-04-13
36	INV-1035	Atlas Ventures	2429.45	pending	2026-03-01	2026-03-22
37	INV-1036	Atlas Ventures	9297.02	paid	2026-04-29	2026-06-01
38	INV-1037	Acme Corp	4057.56	pending	2026-03-23	2026-05-21
39	INV-1038	Peak Solutions	5144.48	paid	2026-03-15	2026-05-13
40	INV-1039	Swift Analytics	2938.26	paid	2026-04-05	2026-03-23
41	INV-1040	Blue Sky Inc	11338.29	pending	2026-02-14	2026-04-26
42	INV-1041	Acme Corp	898.75	paid	2026-04-29	2026-05-24
43	INV-1042	Peak Solutions	2179.85	pending	2026-04-01	2026-05-19
44	INV-1043	Cedar Group	358.06	paid	2026-03-18	2026-04-25
45	INV-1044	Bright Minds Co	8354.71	pending	2026-02-26	2026-04-18
46	INV-1045	Blue Sky Inc	9040.12	paid	2026-02-14	2026-04-03
47	INV-1046	Atlas Ventures	8218.5	pending	2026-04-12	2026-04-03
48	INV-1047	Bright Minds Co	10742.47	pending	2026-04-22	2026-03-23
49	INV-1048	Orbit Digital	7912.07	pending	2026-03-07	2026-04-23
50	INV-1049	Bright Minds Co	6458.16	pending	2026-04-06	2026-04-13
51	INV-1050	Orbit Digital	10459.29	pending	2026-04-30	2026-04-22
52	INV-1051	Atlas Ventures	10013.44	paid	2026-04-17	2026-03-28
53	INV-1052	Nova Systems	11040.69	paid	2026-03-24	2026-05-21
54	INV-1053	Cedar Group	3134.59	paid	2026-04-09	2026-05-06
55	INV-1054	TechWave Ltd	8866.91	paid	2026-03-13	2026-06-05
56	INV-1055	Cedar Group	1657.08	pending	2026-03-06	2026-04-12
57	INV-1056	Blue Sky Inc	6994.88	paid	2026-02-28	2026-05-24
58	INV-1057	Nova Systems	8629.84	overdue	2026-03-12	2026-05-06
59	INV-1058	Peak Solutions	11996.69	pending	2026-03-29	2026-04-02
60	INV-1059	Nova Systems	7679.97	pending	2026-03-08	2026-05-09
61	INV-1060	Bright Minds Co	2943.56	paid	2026-02-15	2026-03-18
62	INV-1061	Bright Minds Co	3955.59	pending	2026-05-03	2026-05-02
63	INV-1062	Bright Minds Co	8044.08	paid	2026-02-16	2026-05-13
64	INV-1063	TechWave Ltd	4881.98	pending	2026-03-31	2026-04-29
65	INV-1064	Peak Solutions	313.04	pending	2026-03-27	2026-06-04
66	INV-1065	Orbit Digital	2274.49	paid	2026-02-25	2026-03-23
67	INV-1066	Orbit Digital	8466.58	paid	2026-03-26	2026-04-28
68	INV-1067	Atlas Ventures	10725.5	paid	2026-05-03	2026-04-03
69	INV-1068	Bright Minds Co	4572.86	paid	2026-05-05	2026-04-10
70	INV-1069	Bright Minds Co	2396.84	pending	2026-03-15	2026-05-01
71	INV-1070	Orbit Digital	9599.49	overdue	2026-04-29	2026-05-06
72	INV-1071	Peak Solutions	8349.58	overdue	2026-04-23	2026-04-16
73	INV-1072	Acme Corp	6317.34	paid	2026-05-05	2026-05-25
74	INV-1073	Bright Minds Co	11680.66	paid	2026-04-02	2026-05-26
75	INV-1074	Atlas Ventures	7469.31	paid	2026-04-17	2026-04-25
76	INV-1075	Atlas Ventures	6945.64	paid	2026-02-23	2026-05-23
77	INV-1076	Nova Systems	9325.63	paid	2026-03-11	2026-04-16
78	INV-1077	Acme Corp	1889.75	overdue	2026-05-04	2026-05-15
79	INV-1078	Orbit Digital	10914.84	paid	2026-03-08	2026-05-01
80	INV-1079	Swift Analytics	6408.96	overdue	2026-04-25	2026-04-17
81	INV-1080	Orbit Digital	5951.03	paid	2026-04-22	2026-06-04
82	INV-1081	Nova Systems	9171.35	overdue	2026-05-05	2026-05-23
83	INV-1082	Bright Minds Co	378.35	paid	2026-03-16	2026-05-10
84	INV-1083	Nova Systems	6964.42	pending	2026-03-03	2026-05-02
85	INV-1084	Atlas Ventures	6146.27	paid	2026-03-03	2026-05-11
86	INV-1085	Orbit Digital	4655.94	paid	2026-02-25	2026-06-06
87	INV-1086	Atlas Ventures	8401.71	overdue	2026-04-17	2026-05-16
88	INV-1087	Orbit Digital	10349.98	pending	2026-04-29	2026-04-28
89	INV-1088	Blue Sky Inc	6457.33	pending	2026-03-11	2026-05-08
90	INV-1089	Peak Solutions	5218.1	paid	2026-03-01	2026-03-25
91	INV-1090	Bright Minds Co	3806.84	pending	2026-04-30	2026-04-23
92	INV-1091	Orbit Digital	1121.42	paid	2026-04-04	2026-05-14
93	INV-1092	Acme Corp	11472.39	pending	2026-03-15	2026-04-18
94	INV-1093	Bright Minds Co	5424.3	pending	2026-03-23	2026-03-18
95	INV-1094	Nova Systems	8410.43	pending	2026-03-25	2026-06-10
96	INV-1095	Blue Sky Inc	1001.95	paid	2026-02-19	2026-05-12
97	INV-1096	Peak Solutions	10976.6	paid	2026-02-28	2026-03-18
98	INV-1097	Orbit Digital	8760.21	paid	2026-05-04	2026-04-17
99	INV-1098	TechWave Ltd	11842.34	overdue	2026-04-29	2026-03-26
100	INV-1099	Swift Analytics	614.65	paid	2026-02-28	2026-04-05
101	INV-1100	Blue Sky Inc	5392.88	paid	2026-04-30	2026-05-02
102	INV-1101	Swift Analytics	11664.22	paid	2026-04-16	2026-04-02
103	INV-1102	TechWave Ltd	8296.33	paid	2026-02-28	2026-04-12
104	INV-1103	Bright Minds Co	2963.03	pending	2026-02-28	2026-03-16
105	INV-1104	Swift Analytics	4649.34	paid	2026-02-23	2026-04-14
106	INV-1105	Nova Systems	8356.36	pending	2026-03-12	2026-04-06
107	INV-1106	Orbit Digital	2745.22	paid	2026-03-19	2026-05-15
108	INV-1107	Peak Solutions	3671.76	paid	2026-02-27	2026-03-20
109	INV-1108	Swift Analytics	6453.87	pending	2026-04-05	2026-04-13
110	INV-1109	Peak Solutions	447.45	paid	2026-05-06	2026-04-01
111	INV-1110	Atlas Ventures	1921.41	overdue	2026-03-07	2026-05-25
112	INV-1111	Acme Corp	2040.34	paid	2026-03-31	2026-03-29
113	INV-1112	Atlas Ventures	8400.07	paid	2026-04-02	2026-06-02
114	INV-1113	Nova Systems	9677.91	pending	2026-03-21	2026-05-31
115	INV-1114	Bright Minds Co	8288.87	overdue	2026-02-14	2026-05-31
116	INV-1115	Swift Analytics	2265.15	overdue	2026-05-05	2026-03-31
117	INV-1116	Blue Sky Inc	4498.77	paid	2026-03-07	2026-05-06
118	INV-1117	Swift Analytics	7252.35	paid	2026-04-24	2026-03-25
119	INV-1118	TechWave Ltd	9329.58	paid	2026-03-01	2026-05-02
120	INV-1119	TechWave Ltd	7653.53	paid	2026-02-24	2026-05-12
\.


--
-- Data for Name: ds_1_sales_orders_a50a19dd; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ds_1_sales_orders_a50a19dd (id, order_id, customer_name, product, category, quantity, unit_price, total_amount, order_date, status, region) FROM stdin;
1	ORD-001	Alice Johnson	Laptop Pro 15	Electronics	2	1299.99	2599.98	2024-01-05	Delivered	North
2	ORD-002	Bob Martinez	Wireless Headphones	Electronics	5	89.99	449.95	2024-01-07	Delivered	South
3	ORD-003	Carol White	Office Chair Deluxe	Furniture	1	349	349	2024-01-10	Shipped	East
4	ORD-004	David Lee	Standing Desk	Furniture	1	599	599	2024-01-12	Processing	West
5	ORD-005	Eva Chen	USB-C Hub 7-in-1	Accessories	10	45.99	459.9	2024-01-15	Delivered	North
6	ORD-006	Frank Brown	4K Monitor 27"	Electronics	2	499.99	999.98	2024-01-18	Delivered	South
7	ORD-007	Grace Kim	Ergonomic Mouse	Accessories	3	59.99	179.97	2024-01-20	Shipped	East
8	ORD-008	Henry Wilson	Mechanical Keyboard	Accessories	4	129.99	519.96	2024-01-22	Delivered	West
9	ORD-009	Isabella Davis	Webcam HD 1080p	Electronics	6	79.99	479.94	2024-01-25	Processing	North
10	ORD-010	James Garcia	Laptop Stand	Accessories	8	39.99	319.92	2024-01-28	Delivered	South
11	ORD-011	Karen Thompson	Tablet Pro 11	Electronics	1	849	849	2024-02-01	Shipped	East
12	ORD-012	Liam Robinson	Desk Lamp LED	Furniture	5	29.99	149.95	2024-02-03	Delivered	West
13	ORD-013	Mia Anderson	Smart Speaker	Electronics	2	199.99	399.98	2024-02-05	Delivered	North
14	ORD-014	Noah Jackson	Cable Management Kit	Accessories	12	14.99	179.88	2024-02-08	Delivered	South
15	ORD-015	Olivia Harris	Gaming Chair	Furniture	1	449	449	2024-02-10	Processing	East
16	ORD-016	Paul Martinez	External SSD 1TB	Electronics	3	109.99	329.97	2024-02-12	Shipped	West
17	ORD-017	Quinn Taylor	Monitor Arm Dual	Accessories	2	89.99	179.98	2024-02-15	Delivered	North
18	ORD-018	Rachel Moore	Noise Cancel Earpods	Electronics	4	249	996	2024-02-18	Delivered	South
19	ORD-019	Samuel Clark	Portable Charger	Accessories	7	49.99	349.93	2024-02-20	Delivered	East
20	ORD-020	Tina Lewis	Smart Watch Series 5	Electronics	2	399	798	2024-02-22	Shipped	West
\.


--
-- Data for Name: ds_1_test_74ec9ab8; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ds_1_test_74ec9ab8 (id, caseid, image_filename, mask_tumor_filename, mask_other_filename, pixel_size, age, tissue_composition, signs, symptoms, shape, margin, echogenicity, posterior_features, halo, calcifications, skin_thickening, interpretation, birads, verification, diagnosis, classification) FROM stdin;
\.


--
-- Data for Name: ds_2_products_seed; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ds_2_products_seed (id, product_id, name, category, price, stock, supplier) FROM stdin;
1	SKU-1323	USB-C Hub	Furniture	372.73	291	OfficeMax Supply
2	SKU-1738	USB-C Hub	Electronics	210.02	194	SupplyCo
3	SKU-7244	Blue Light Glasses	Electronics	92.29	386	OfficeMax Supply
4	SKU-7129	Headset Pro	Electronics	198.84	485	SupplyCo
5	SKU-6629	Desk Pad	Furniture	273.44	431	TechDistrib
6	SKU-9622	Webcam HD	Accessories	353.15	167	GlobalParts Inc
7	SKU-2425	Ergonomic Mouse	Furniture	72.54	497	OfficeMax Supply
8	SKU-3816	Desk Pad	Peripherals	298.21	434	GlobalParts Inc
9	SKU-4146	Desk Organizer	Stationery	361.63	26	GlobalParts Inc
10	SKU-2519	Cable Tray	Stationery	474.7	326	TechDistrib
11	SKU-3566	Screen Cleaner	Peripherals	139.35	424	GlobalParts Inc
12	SKU-4846	Blue Light Glasses	Furniture	381.43	373	GlobalParts Inc
13	SKU-8164	Whiteboard Pack	Stationery	12.12	52	TechDistrib
14	SKU-9404	Desk Pad	Peripherals	159.9	244	TechDistrib
15	SKU-3897	USB-C Hub	Peripherals	374.01	386	GlobalParts Inc
16	SKU-5595	Headset Pro	Stationery	356.53	462	OfficeMax Supply
17	SKU-7285	Webcam HD	Accessories	419.18	109	OfficeMax Supply
18	SKU-7579	Screen Cleaner	Electronics	457.81	351	GlobalParts Inc
19	SKU-6857	Desk Organizer	Electronics	385.43	303	TechDistrib
20	SKU-1232	Webcam HD	Stationery	81.24	73	OfficeMax Supply
21	SKU-2282	Monitor Light	Accessories	234.5	227	GlobalParts Inc
22	SKU-2428	Webcam HD	Stationery	105.68	384	OfficeMax Supply
23	SKU-8455	Cable Tray	Accessories	218.87	452	OfficeMax Supply
24	SKU-8146	Standing Mat	Furniture	161.65	462	OfficeMax Supply
25	SKU-7468	Desk Organizer	Electronics	303.57	171	TechDistrib
26	SKU-4891	Wireless Keyboard	Peripherals	237.53	49	TechDistrib
27	SKU-8884	Headset Pro	Stationery	422.03	386	SupplyCo
28	SKU-4133	Standing Mat	Accessories	207.96	147	TechDistrib
29	SKU-2779	Ergonomic Mouse	Peripherals	197.99	403	GlobalParts Inc
30	SKU-9863	Webcam HD	Furniture	330.63	233	OfficeMax Supply
31	SKU-8050	Headset Pro	Furniture	60.04	86	OfficeMax Supply
32	SKU-8910	Standing Mat	Peripherals	473.04	189	SupplyCo
33	SKU-9472	Desk Organizer	Furniture	309.35	189	TechDistrib
34	SKU-6556	Cable Tray	Peripherals	207.31	149	OfficeMax Supply
35	SKU-6271	Blue Light Glasses	Accessories	273.76	489	SupplyCo
36	SKU-8549	Desk Organizer	Stationery	15.35	404	GlobalParts Inc
37	SKU-8761	Cable Tray	Peripherals	479.82	74	TechDistrib
38	SKU-2823	Webcam HD	Accessories	31.87	60	GlobalParts Inc
39	SKU-5335	Wireless Keyboard	Accessories	273.03	316	SupplyCo
40	SKU-5512	USB-C Hub	Furniture	195.24	153	OfficeMax Supply
41	SKU-8416	Cable Tray	Furniture	22.14	388	SupplyCo
42	SKU-7127	Ergonomic Mouse	Peripherals	395.98	374	OfficeMax Supply
43	SKU-3820	Pro Laptop Stand	Peripherals	244.67	209	TechDistrib
44	SKU-1415	Desk Pad	Accessories	236.99	115	GlobalParts Inc
45	SKU-1760	Screen Cleaner	Stationery	358.82	161	TechDistrib
46	SKU-5910	Monitor Light	Electronics	343.87	163	SupplyCo
47	SKU-2102	Desk Pad	Furniture	375.49	316	GlobalParts Inc
48	SKU-8545	Ergonomic Mouse	Furniture	381.56	370	GlobalParts Inc
49	SKU-2890	Headset Pro	Peripherals	111.93	317	OfficeMax Supply
50	SKU-1417	Wireless Keyboard	Peripherals	483.82	128	TechDistrib
51	SKU-4710	Standing Mat	Accessories	29.56	261	SupplyCo
52	SKU-5143	Ergonomic Mouse	Stationery	150.64	480	TechDistrib
53	SKU-9760	Standing Mat	Electronics	201.74	42	SupplyCo
54	SKU-8111	Headset Pro	Electronics	197.48	371	OfficeMax Supply
55	SKU-1771	Cable Tray	Peripherals	499.86	315	OfficeMax Supply
56	SKU-5034	Monitor Light	Electronics	286.52	347	TechDistrib
57	SKU-6347	USB-C Hub	Stationery	374.18	499	OfficeMax Supply
58	SKU-3050	Monitor Light	Accessories	66.63	199	OfficeMax Supply
59	SKU-6721	Wireless Keyboard	Peripherals	406.63	367	GlobalParts Inc
60	SKU-1675	Webcam HD	Electronics	319.14	129	TechDistrib
61	SKU-6608	USB-C Hub	Electronics	354.56	297	GlobalParts Inc
62	SKU-3263	Screen Cleaner	Peripherals	146.92	485	SupplyCo
63	SKU-2778	Standing Mat	Electronics	225.93	59	GlobalParts Inc
64	SKU-1692	Wireless Keyboard	Stationery	457.45	290	TechDistrib
65	SKU-6460	Webcam HD	Furniture	302.27	129	GlobalParts Inc
66	SKU-2091	Headset Pro	Peripherals	410.25	403	OfficeMax Supply
67	SKU-6887	Screen Cleaner	Peripherals	77.92	59	SupplyCo
68	SKU-5026	Desk Organizer	Stationery	322.26	487	TechDistrib
69	SKU-8498	Wireless Keyboard	Furniture	238.89	321	OfficeMax Supply
70	SKU-9361	HDMI Switch	Accessories	165.24	439	GlobalParts Inc
71	SKU-7907	Desk Pad	Accessories	379.72	396	SupplyCo
72	SKU-5851	Standing Mat	Furniture	125.73	113	OfficeMax Supply
73	SKU-1891	Desk Pad	Furniture	59.11	13	OfficeMax Supply
74	SKU-1204	Blue Light Glasses	Furniture	356.43	102	OfficeMax Supply
75	SKU-2945	Webcam HD	Accessories	209.03	125	OfficeMax Supply
76	SKU-9037	Ergonomic Mouse	Electronics	107.02	112	SupplyCo
77	SKU-1436	Monitor Light	Electronics	404.24	366	SupplyCo
78	SKU-3024	Desk Pad	Furniture	455.08	428	GlobalParts Inc
79	SKU-7676	Standing Mat	Electronics	53.91	21	SupplyCo
80	SKU-9908	Standing Mat	Electronics	11.23	3	TechDistrib
\.


--
-- Data for Name: ds_2_sales_seed; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ds_2_sales_seed (id, sale_id, product, region, quantity, revenue, sale_date, rep_name) FROM stdin;
1	SL-02000	Webcam HD	Middle East	24	234.01	2026-04-07	Sam Rivera
2	SL-02001	Webcam HD	Middle East	7	6560.11	2026-03-07	Alex Turner
3	SL-02002	Ergonomic Mouse	Europe	43	5672.6	2026-04-25	Morgan Patel
4	SL-02003	Webcam HD	North America	6	4747.95	2026-03-05	Morgan Patel
5	SL-02004	Ergonomic Mouse	Middle East	7	3999.29	2026-03-27	Sam Rivera
6	SL-02005	Webcam HD	Europe	13	589.4	2026-04-17	Taylor Kim
7	SL-02006	Webcam HD	Latin America	4	7735.81	2026-02-25	Morgan Patel
8	SL-02007	Ergonomic Mouse	Europe	50	3417.77	2026-02-20	Jordan Lee
9	SL-02008	Monitor Light	Latin America	25	2761.98	2026-02-09	Morgan Patel
10	SL-02009	Wireless Keyboard	Latin America	32	434.63	2026-05-12	Morgan Patel
11	SL-02010	Pro Laptop Stand	Asia Pacific	28	7034.05	2025-12-19	Jordan Lee
12	SL-02011	USB-C Hub	North America	26	1041.94	2026-02-20	Alex Turner
13	SL-02012	Wireless Keyboard	Middle East	6	6544.66	2025-12-21	Jordan Lee
14	SL-02013	Pro Laptop Stand	North America	27	2994.38	2026-05-09	Sam Rivera
15	SL-02014	Webcam HD	Latin America	40	4031.24	2026-04-23	Morgan Patel
16	SL-02015	Ergonomic Mouse	Europe	5	5535.5	2026-02-10	Alex Turner
17	SL-02016	USB-C Hub	Europe	36	4879.29	2026-01-09	Taylor Kim
18	SL-02017	Webcam HD	Asia Pacific	23	1918.2	2026-02-27	Jordan Lee
19	SL-02018	Wireless Keyboard	Latin America	27	4444.14	2026-02-14	Morgan Patel
20	SL-02019	Ergonomic Mouse	Middle East	2	3220.02	2026-01-21	Jordan Lee
21	SL-02020	Ergonomic Mouse	Latin America	17	5527.79	2026-01-10	Sam Rivera
22	SL-02021	Wireless Keyboard	North America	32	7198.68	2026-02-05	Alex Turner
23	SL-02022	USB-C Hub	Middle East	28	5701.65	2026-03-25	Sam Rivera
24	SL-02023	USB-C Hub	Asia Pacific	34	3411.78	2025-12-30	Alex Turner
25	SL-02024	Pro Laptop Stand	Europe	27	2890.86	2026-01-18	Sam Rivera
26	SL-02025	Webcam HD	Asia Pacific	15	2615.96	2026-05-11	Taylor Kim
27	SL-02026	Webcam HD	Asia Pacific	5	3080.07	2026-04-24	Jordan Lee
28	SL-02027	USB-C Hub	Latin America	44	2816.04	2026-04-15	Taylor Kim
29	SL-02028	Monitor Light	Middle East	21	7238.21	2026-01-31	Sam Rivera
30	SL-02029	Monitor Light	North America	20	4139.82	2026-04-28	Jordan Lee
31	SL-02030	USB-C Hub	North America	40	4791	2026-05-01	Taylor Kim
32	SL-02031	Monitor Light	Middle East	11	4684.15	2026-03-20	Morgan Patel
33	SL-02032	Ergonomic Mouse	Middle East	21	4661.78	2026-02-13	Sam Rivera
34	SL-02033	Pro Laptop Stand	Asia Pacific	22	1465.6	2026-04-07	Alex Turner
35	SL-02034	Webcam HD	Europe	19	400.66	2026-02-17	Morgan Patel
36	SL-02035	Wireless Keyboard	Asia Pacific	37	6308.29	2026-01-16	Morgan Patel
37	SL-02036	Webcam HD	Middle East	31	1699.02	2026-04-19	Sam Rivera
38	SL-02037	Wireless Keyboard	Asia Pacific	46	1045.32	2026-01-13	Taylor Kim
39	SL-02038	USB-C Hub	Middle East	47	5427.45	2025-12-18	Morgan Patel
40	SL-02039	Wireless Keyboard	Latin America	9	4178.48	2026-01-08	Sam Rivera
41	SL-02040	Pro Laptop Stand	Middle East	38	1618.44	2026-01-17	Morgan Patel
42	SL-02041	Monitor Light	North America	17	5543.43	2026-04-13	Jordan Lee
43	SL-02042	USB-C Hub	Europe	17	2542.79	2025-12-29	Alex Turner
44	SL-02043	Pro Laptop Stand	Europe	36	206.23	2026-01-31	Jordan Lee
45	SL-02044	USB-C Hub	North America	5	650.14	2026-04-21	Taylor Kim
46	SL-02045	Ergonomic Mouse	Middle East	48	619.37	2025-12-23	Alex Turner
47	SL-02046	Monitor Light	Latin America	28	6481.08	2026-04-13	Jordan Lee
48	SL-02047	USB-C Hub	Europe	9	1853.07	2026-01-18	Morgan Patel
49	SL-02048	USB-C Hub	North America	27	7387.73	2026-01-14	Morgan Patel
50	SL-02049	Webcam HD	Middle East	15	7057.59	2026-04-05	Alex Turner
51	SL-02050	Webcam HD	Middle East	20	1924.46	2026-04-06	Taylor Kim
52	SL-02051	Webcam HD	Middle East	21	1198.07	2026-03-15	Taylor Kim
53	SL-02052	Ergonomic Mouse	North America	13	1609.9	2026-02-21	Alex Turner
54	SL-02053	USB-C Hub	Europe	6	2625.36	2026-01-26	Alex Turner
55	SL-02054	Pro Laptop Stand	Middle East	37	3570.49	2026-03-11	Alex Turner
56	SL-02055	Pro Laptop Stand	Middle East	23	5866.17	2025-12-20	Jordan Lee
57	SL-02056	Ergonomic Mouse	Latin America	23	7503.12	2026-01-16	Alex Turner
58	SL-02057	Pro Laptop Stand	North America	4	2566.32	2026-02-02	Taylor Kim
59	SL-02058	Wireless Keyboard	Latin America	19	490.99	2026-01-26	Morgan Patel
60	SL-02059	Webcam HD	Middle East	40	5595.23	2026-03-31	Alex Turner
61	SL-02060	Ergonomic Mouse	Middle East	36	1680.67	2026-04-01	Jordan Lee
62	SL-02061	Ergonomic Mouse	Asia Pacific	24	6672.57	2025-12-21	Alex Turner
63	SL-02062	Wireless Keyboard	North America	29	611.48	2026-05-04	Morgan Patel
64	SL-02063	USB-C Hub	Latin America	25	6920.78	2026-01-11	Alex Turner
65	SL-02064	Ergonomic Mouse	Latin America	6	3209.5	2026-04-09	Jordan Lee
66	SL-02065	USB-C Hub	Middle East	19	3315.9	2026-01-31	Sam Rivera
67	SL-02066	Webcam HD	Middle East	11	4202.76	2025-12-15	Alex Turner
68	SL-02067	Webcam HD	Middle East	38	5395.29	2026-04-08	Sam Rivera
69	SL-02068	Pro Laptop Stand	North America	17	1093.06	2026-04-05	Morgan Patel
70	SL-02069	Ergonomic Mouse	Asia Pacific	23	1400.59	2025-12-30	Jordan Lee
71	SL-02070	Wireless Keyboard	Latin America	50	7032.51	2026-01-12	Morgan Patel
72	SL-02071	Pro Laptop Stand	Europe	7	278.91	2026-03-23	Sam Rivera
73	SL-02072	Wireless Keyboard	Latin America	10	2856.41	2026-02-22	Alex Turner
74	SL-02073	Wireless Keyboard	Europe	21	3255.16	2026-03-07	Taylor Kim
75	SL-02074	Pro Laptop Stand	Latin America	9	660.04	2026-01-12	Jordan Lee
76	SL-02075	Monitor Light	North America	48	6314.29	2026-04-11	Alex Turner
77	SL-02076	Ergonomic Mouse	Latin America	24	6970.81	2025-12-27	Morgan Patel
78	SL-02077	Monitor Light	Middle East	29	2334.12	2026-04-16	Sam Rivera
79	SL-02078	Webcam HD	Asia Pacific	50	1402.21	2026-05-08	Jordan Lee
80	SL-02079	USB-C Hub	Middle East	4	3124.79	2026-03-18	Sam Rivera
81	SL-02080	USB-C Hub	North America	18	7300.96	2026-03-10	Jordan Lee
82	SL-02081	Ergonomic Mouse	Latin America	50	2992.47	2025-12-18	Taylor Kim
83	SL-02082	Ergonomic Mouse	North America	11	5805.99	2026-01-23	Alex Turner
84	SL-02083	Wireless Keyboard	Latin America	43	212.95	2026-03-22	Taylor Kim
85	SL-02084	Webcam HD	Asia Pacific	46	4565.63	2026-02-25	Sam Rivera
86	SL-02085	Monitor Light	Latin America	38	6533.43	2026-05-05	Morgan Patel
87	SL-02086	Ergonomic Mouse	North America	50	1724.62	2026-02-01	Jordan Lee
88	SL-02087	Webcam HD	Latin America	19	2250.88	2026-01-06	Morgan Patel
89	SL-02088	Ergonomic Mouse	Latin America	31	1612.65	2026-03-09	Jordan Lee
90	SL-02089	Ergonomic Mouse	Asia Pacific	2	2845.13	2026-02-22	Sam Rivera
91	SL-02090	Wireless Keyboard	North America	16	5074.87	2026-03-07	Sam Rivera
92	SL-02091	USB-C Hub	North America	30	2326.71	2026-04-13	Sam Rivera
93	SL-02092	Pro Laptop Stand	North America	41	4540.02	2026-03-07	Sam Rivera
94	SL-02093	Webcam HD	Middle East	21	3337.89	2026-04-28	Alex Turner
95	SL-02094	Wireless Keyboard	Middle East	20	918.23	2026-01-20	Sam Rivera
96	SL-02095	Ergonomic Mouse	Middle East	32	2432.21	2026-03-27	Taylor Kim
97	SL-02096	Webcam HD	Middle East	1	3367.63	2026-01-10	Taylor Kim
98	SL-02097	Webcam HD	Latin America	40	783.35	2026-04-07	Taylor Kim
99	SL-02098	Wireless Keyboard	Middle East	5	771.44	2026-03-12	Alex Turner
100	SL-02099	Webcam HD	North America	16	4163.92	2026-04-02	Jordan Lee
101	SL-02100	Pro Laptop Stand	Latin America	47	2541.27	2026-04-26	Taylor Kim
102	SL-02101	Webcam HD	Asia Pacific	45	599.97	2026-04-23	Sam Rivera
103	SL-02102	Monitor Light	Middle East	33	1207.57	2026-01-26	Morgan Patel
104	SL-02103	Ergonomic Mouse	Europe	5	2766.84	2026-02-02	Sam Rivera
105	SL-02104	Monitor Light	Middle East	18	5396.47	2026-02-23	Jordan Lee
106	SL-02105	Wireless Keyboard	Latin America	19	7129.68	2026-02-14	Jordan Lee
107	SL-02106	USB-C Hub	Europe	46	4670.76	2025-12-17	Sam Rivera
108	SL-02107	Ergonomic Mouse	Europe	44	6112.72	2026-03-30	Sam Rivera
109	SL-02108	Monitor Light	North America	3	2119.5	2026-03-15	Taylor Kim
110	SL-02109	Ergonomic Mouse	Latin America	24	4047.76	2026-02-25	Morgan Patel
111	SL-02110	Pro Laptop Stand	Middle East	37	4336.13	2025-12-23	Alex Turner
112	SL-02111	Ergonomic Mouse	Europe	24	1216.88	2026-04-24	Sam Rivera
113	SL-02112	Wireless Keyboard	Europe	15	2686.17	2026-02-24	Alex Turner
114	SL-02113	USB-C Hub	Middle East	4	1319.81	2026-04-11	Jordan Lee
115	SL-02114	Webcam HD	Middle East	14	2674.8	2026-03-31	Jordan Lee
116	SL-02115	Monitor Light	Middle East	36	4762.34	2026-01-03	Jordan Lee
117	SL-02116	USB-C Hub	Europe	10	2182.88	2026-01-07	Taylor Kim
118	SL-02117	USB-C Hub	North America	46	4905.78	2026-04-20	Jordan Lee
119	SL-02118	Ergonomic Mouse	Latin America	18	4259.38	2026-05-11	Morgan Patel
120	SL-02119	Wireless Keyboard	Middle East	34	5339.51	2026-04-22	Sam Rivera
121	SL-02120	Ergonomic Mouse	Asia Pacific	10	917.67	2026-04-04	Morgan Patel
122	SL-02121	USB-C Hub	Europe	44	4284.36	2025-12-17	Morgan Patel
123	SL-02122	Ergonomic Mouse	Europe	23	132.17	2026-02-05	Jordan Lee
124	SL-02123	Pro Laptop Stand	Latin America	1	7368.41	2026-03-02	Alex Turner
125	SL-02124	Pro Laptop Stand	North America	26	5938.84	2026-01-01	Alex Turner
126	SL-02125	USB-C Hub	Europe	29	3842.75	2026-03-15	Taylor Kim
127	SL-02126	USB-C Hub	Latin America	39	4206	2026-01-06	Taylor Kim
128	SL-02127	Wireless Keyboard	Europe	43	2520.57	2026-02-07	Sam Rivera
129	SL-02128	Ergonomic Mouse	Middle East	18	5873.11	2026-01-13	Jordan Lee
130	SL-02129	Ergonomic Mouse	Asia Pacific	6	6241.7	2026-05-01	Morgan Patel
131	SL-02130	Monitor Light	Europe	36	720.08	2026-05-03	Jordan Lee
132	SL-02131	Monitor Light	North America	14	5230.07	2026-04-05	Alex Turner
133	SL-02132	Webcam HD	Middle East	29	1866.54	2025-12-26	Taylor Kim
134	SL-02133	Ergonomic Mouse	North America	30	356.93	2025-12-14	Morgan Patel
135	SL-02134	USB-C Hub	Middle East	1	6302.51	2026-01-02	Taylor Kim
136	SL-02135	USB-C Hub	Asia Pacific	11	795.97	2025-12-28	Taylor Kim
137	SL-02136	Webcam HD	North America	36	7757.97	2026-01-16	Taylor Kim
138	SL-02137	Wireless Keyboard	North America	1	4967.09	2026-01-11	Sam Rivera
139	SL-02138	USB-C Hub	Asia Pacific	1	3013.53	2026-03-15	Morgan Patel
140	SL-02139	Pro Laptop Stand	Asia Pacific	26	6968.86	2026-04-22	Taylor Kim
141	SL-02140	Ergonomic Mouse	North America	13	5686.23	2026-03-02	Alex Turner
142	SL-02141	USB-C Hub	Middle East	24	1963.59	2026-04-18	Jordan Lee
143	SL-02142	Wireless Keyboard	Latin America	14	1145.37	2026-01-22	Alex Turner
144	SL-02143	Pro Laptop Stand	Asia Pacific	32	7642.87	2026-04-13	Sam Rivera
145	SL-02144	Webcam HD	Latin America	45	303.85	2026-04-10	Taylor Kim
146	SL-02145	Pro Laptop Stand	Europe	29	1268	2026-03-04	Taylor Kim
147	SL-02146	Ergonomic Mouse	Middle East	18	3487.3	2026-02-10	Alex Turner
148	SL-02147	Monitor Light	Europe	20	4835.26	2026-03-02	Morgan Patel
149	SL-02148	Webcam HD	Middle East	29	3699.29	2026-04-15	Sam Rivera
150	SL-02149	Monitor Light	Latin America	31	2292.28	2025-12-28	Sam Rivera
151	SL-02150	Wireless Keyboard	Middle East	1	6204.91	2026-01-13	Taylor Kim
152	SL-02151	Wireless Keyboard	North America	2	2929.33	2026-04-11	Sam Rivera
153	SL-02152	Wireless Keyboard	Europe	12	7604.08	2026-03-28	Sam Rivera
154	SL-02153	Ergonomic Mouse	North America	23	4073.93	2026-01-23	Alex Turner
155	SL-02154	Webcam HD	Europe	48	5530.82	2026-01-23	Jordan Lee
156	SL-02155	Webcam HD	North America	1	1463.05	2026-01-02	Alex Turner
157	SL-02156	Wireless Keyboard	North America	18	275.9	2026-03-02	Alex Turner
158	SL-02157	Monitor Light	Europe	44	5458.07	2025-12-16	Morgan Patel
159	SL-02158	Webcam HD	Middle East	32	1528.83	2026-03-31	Jordan Lee
160	SL-02159	USB-C Hub	North America	46	5687.84	2026-02-11	Jordan Lee
161	SL-02160	Monitor Light	Middle East	14	5677.96	2026-01-28	Morgan Patel
162	SL-02161	Monitor Light	Latin America	10	3122.82	2026-05-01	Jordan Lee
163	SL-02162	Wireless Keyboard	North America	8	141.77	2026-01-26	Jordan Lee
164	SL-02163	Ergonomic Mouse	North America	21	7948.24	2026-03-09	Jordan Lee
165	SL-02164	Monitor Light	Europe	7	6480.03	2026-03-31	Jordan Lee
166	SL-02165	Pro Laptop Stand	Latin America	16	7806.11	2025-12-14	Jordan Lee
167	SL-02166	Monitor Light	North America	50	3128.78	2026-03-30	Alex Turner
168	SL-02167	Webcam HD	North America	26	7531.37	2025-12-18	Morgan Patel
169	SL-02168	Wireless Keyboard	Europe	48	4811.3	2026-04-28	Morgan Patel
170	SL-02169	Monitor Light	Middle East	37	4737.87	2026-02-01	Jordan Lee
171	SL-02170	Pro Laptop Stand	Europe	25	7933.92	2026-03-01	Alex Turner
172	SL-02171	Monitor Light	Latin America	39	7387.32	2025-12-15	Sam Rivera
173	SL-02172	Monitor Light	North America	36	744.39	2026-04-12	Alex Turner
174	SL-02173	Wireless Keyboard	North America	13	3658.17	2026-02-24	Morgan Patel
175	SL-02174	Monitor Light	Europe	6	5044.18	2026-02-11	Alex Turner
176	SL-02175	USB-C Hub	Asia Pacific	6	1175.8	2026-04-06	Alex Turner
177	SL-02176	Monitor Light	Latin America	18	1326.71	2026-01-06	Jordan Lee
178	SL-02177	Pro Laptop Stand	Asia Pacific	50	1874.85	2026-02-12	Jordan Lee
179	SL-02178	Wireless Keyboard	Asia Pacific	22	5246.24	2026-03-25	Sam Rivera
180	SL-02179	Monitor Light	Latin America	9	3348.69	2026-01-16	Sam Rivera
181	SL-02180	USB-C Hub	Middle East	16	3935.22	2026-04-28	Sam Rivera
182	SL-02181	Pro Laptop Stand	Middle East	3	3278.3	2026-01-18	Morgan Patel
183	SL-02182	Webcam HD	North America	48	385.7	2026-03-07	Jordan Lee
184	SL-02183	USB-C Hub	Latin America	38	4080.89	2026-03-02	Alex Turner
185	SL-02184	Ergonomic Mouse	Asia Pacific	27	1234.31	2026-01-09	Morgan Patel
186	SL-02185	Pro Laptop Stand	Latin America	29	4159.9	2025-12-19	Morgan Patel
187	SL-02186	USB-C Hub	Latin America	16	5468.31	2026-02-15	Alex Turner
188	SL-02187	Wireless Keyboard	Latin America	9	7072.93	2026-04-23	Jordan Lee
189	SL-02188	Ergonomic Mouse	North America	20	4894.79	2026-04-14	Morgan Patel
190	SL-02189	Ergonomic Mouse	Asia Pacific	20	1062.83	2026-05-04	Jordan Lee
191	SL-02190	Monitor Light	North America	31	4296.64	2026-03-24	Alex Turner
192	SL-02191	Pro Laptop Stand	Middle East	15	6206.57	2026-04-02	Morgan Patel
193	SL-02192	Pro Laptop Stand	Asia Pacific	13	6745.17	2026-01-02	Alex Turner
194	SL-02193	Pro Laptop Stand	Asia Pacific	35	1972.43	2026-05-08	Alex Turner
195	SL-02194	Webcam HD	Latin America	29	6911.94	2026-01-26	Jordan Lee
196	SL-02195	Wireless Keyboard	Latin America	18	6892.75	2025-12-28	Sam Rivera
197	SL-02196	Webcam HD	Middle East	32	3554.96	2026-01-10	Sam Rivera
198	SL-02197	Ergonomic Mouse	Middle East	29	1360.3	2026-04-02	Morgan Patel
199	SL-02198	USB-C Hub	Latin America	40	757.27	2026-04-05	Alex Turner
200	SL-02199	Wireless Keyboard	Europe	26	5500.36	2026-03-04	Sam Rivera
\.


--
-- Data for Name: ds_3_breast_dataset_c6c9cc35; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ds_3_breast_dataset_c6c9cc35 (id, caseid, image_filename, mask_tumor_filename, mask_other_filename, pixel_size, age, tissue_composition, signs, symptoms, shape, margin, echogenicity, posterior_features, halo, calcifications, skin_thickening, interpretation, birads, verification, diagnosis, classification) FROM stdin;
1	1	case001.png	case001_tumor.png	NaN	0.0078125	57	heterogeneous: predominantly fat	breast scar	family history of breast/ovarian cancer	irregular	not circumscribed - indistinct	heterogeneous	shadowing	no	no	yes	Breast scar (surgery)&Breast scar (radiotherapy)	2	confirmed by follow-up care	not applicable	benign
2	2	case002.png	case002_tumor.png	NaN	0.006462036	not available	homogeneous: fat	not available	not available	oval	not circumscribed - indistinct	hypoechoic	no	no	no	no	Dysplasia&Fibroadenoma	4b	confirmed by biopsy	Intramammary lymph node	benign
3	3	case003.png	case003_tumor.png	NaN	0.006944444	56	heterogeneous: predominantly fat	no	nipple discharge	oval	circumscribed	hyperechoic	no	no	no	no	Duct filled with thick fluid&Intraductal papilloma	4a	confirmed by biopsy	Usual ductal hyperplasia (UDH)&Pseudoangiomatous stromal hyperplasia (PASH)	benign
4	4	case004.png	case004_tumor.png	NaN	0.0078125	43	homogeneous: fibroglandular	no	no	round	circumscribed	hypoechoic	no	no	no	no	Cyst filled with thick fluid	3	confirmed by follow-up care	not applicable	benign
5	5	case005.png	case005_tumor.png	NaN	0.0078125	67	homogeneous: fat	nipple retraction&palpable	family history of breast/ovarian cancer	oval	circumscribed	complex cystic/solid	enhancement	no	no	no	Suspicion of malignancy&Intraductal papilloma	4b	confirmed by biopsy	Encapsulated papillary carcinoma&Ductal carcinoma in situ (DCIS)	malignant
6	6	case006.png	case006_tumor.png	NaN	0.0078125	56	heterogeneous: predominantly fat	no	HRT/hormonal contraception	irregular	not circumscribed - indistinct	heterogeneous	no	no	intraductal	no	Suspicion of malignancy&Intraductal papilloma&Mastitis	4b	confirmed by biopsy	Fibrosclerosis	benign
7	7	case007.png	case007_tumor.png	NaN	0.0078125	52	heterogeneous: predominantly fat	palpable	not available	irregular	not circumscribed - spiculated&indistinct	hypoechoic	shadowing	no	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
8	8	case008.png	case008_tumor.png	NaN	0.005902192	not available	heterogeneous: predominantly fat	no	no	irregular	not circumscribed - spiculated&angular&indistinct	hypoechoic	shadowing	no	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
9	9	case009.png	case009_tumor.png	NaN	0.01035503	76	heterogeneous: predominantly fibroglandular	no	not available	irregular	not circumscribed - microlobulated	hypoechoic	no	no	no	no	Suspicion of malignancy&Dysplasia	4b	confirmed by biopsy	Fibrosclerosis	benign
10	10	case010.png	case010_tumor.png	NaN	0.01078	34	not available	not available	not available	irregular	not circumscribed - angular&indistinct	hypoechoic	enhancement	yes	no	no	Suspicion of malignancy&Dysplasia&Fibroadenoma&Intraductal papilloma	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)&Ductal carcinoma in situ (DCIS)	malignant
11	11	case011.png	case011_tumor.png	NaN	0.008680556	70	heterogeneous: predominantly fibroglandular	palpable	family history of breast/ovarian cancer	irregular	not circumscribed - indistinct	hypoechoic	shadowing	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
12	12	case012.png	case012_tumor.png	NaN	0.01078	74	not available	not available	not available	irregular	not circumscribed - angular&indistinct	hypoechoic	enhancement	yes	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)&Invasive micropapillary carcinoma	malignant
13	13	case013.png	case013_tumor.png	NaN	0.0078125	53	heterogeneous: predominantly fat	no	no	irregular	not circumscribed - spiculated&angular&indistinct	hypoechoic	shadowing	yes	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
14	14	case014.png	case014_tumor.png	NaN	0.006944444	39	homogeneous: fibroglandular	palpable	family history of breast/ovarian cancer&HRT/hormonal contraception	oval	circumscribed	heterogeneous	enhancement	no	no	no	Cyst filled with thick fluid&Fibroadenoma	4a	confirmed by biopsy	Fibrosclerosis	benign
15	15	case015.png	case015_tumor.png	NaN	0.008680556	47	heterogeneous: predominantly fibroglandular	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Complex cyst / Non-simple cyst&Cyst filled with thick fluid&Duct filled with thick fluid&Mammary duct ectasia&Intraductal papilloma	4a	confirmed by biopsy	Benign mammary dysplasia	benign
16	16	case016.png	case016_tumor.png	NaN	0.006076389	52	homogeneous: fibroglandular	no	no	oval	circumscribed	hypoechoic	shadowing	no	no	no	Complex cyst / Non-simple cyst&Cyst filled with thick fluid&Fibroadenoma	4a	confirmed by biopsy	Usual ductal hyperplasia (UDH)	benign
17	17	case017.png	case017_tumor.png	NaN	0.005181347	57	heterogeneous: predominantly fat	no	not available	oval	circumscribed	complex cystic/solid	no	no	no	no	Dysplasia&Mammary duct ectasia	3	confirmed by follow-up care	not applicable	benign
18	18	case018.png	case018_tumor.png	NaN	0.0078125	66	heterogeneous: predominantly fat	not available	not available	oval	circumscribed	hypoechoic	no	no	no	no	Suspicion of malignancy&Fibroadenoma	4b	confirmed by biopsy	Fibroadenoma	benign
19	19	case019.png	case019_tumor.png	NaN	0.006462036	47	homogeneous: fibroglandular	no	not available	oval	circumscribed	heterogeneous	no	no	no	no	Suspicion of malignancy&Intraductal papilloma	4b	confirmed by biopsy	Intraductal papilloma	benign
20	20	case020.png	case020_tumor.png	NaN	0.006462036	21	heterogeneous: predominantly fibroglandular	no	not available	oval	circumscribed	hypoechoic	enhancement	no	no	no	Cyst filled with thick fluid	2	confirmed by follow-up care	not applicable	benign
21	21	case021.png	case021_tumor.png	NaN	0.0078125	42	homogeneous: fibroglandular	palpable	HRT/hormonal contraception	oval	circumscribed	heterogeneous	no	no	no	no	Fibroadenoma&Hamartoma	4a	confirmed by biopsy	Fibroadenoma	benign
22	22	case022.png	case022_tumor.png	case022_other1.png&case022_other2.png	0.0078125	51	heterogeneous: predominantly fibroglandular	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Dysplasia&Fibroadenoma&Intraductal papilloma	4b	confirmed by biopsy	Fibroadenoma	benign
23	23	case023.png	case023_tumor.png	NaN	0.006944444	65	heterogeneous: predominantly fat	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Cyst filled with thick fluid&Dysplasia&Fibroadenoma	4a	confirmed by biopsy	Benign mammary dysplasia	benign
24	24	case024.png	case024_tumor.png	NaN	0.01078	40	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	enhancement	yes	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4b	confirmed by biopsy	Fibroadenoma	benign
25	25	case025.png	case025_tumor.png	NaN	0.006462036	38	heterogeneous: predominantly fibroglandular	no	not available	oval	circumscribed	heterogeneous	enhancement	no	no	no	Fibroadenoma	4a	confirmed by biopsy	Fibroadenoma	benign
26	26	case026.png	case026_tumor.png	NaN	0.005208333	45	homogeneous: fibroglandular	palpable	no	irregular	not circumscribed - indistinct	hypoechoic	no	no	in a mass	no	Suspicion of malignancy	4c	confirmed by biopsy	Tubular carcinoma&Cribriform carcinoma	malignant
27	27	case027.png	case027_tumor.png	NaN	0.01078	80	not available	not available	not available	irregular	not circumscribed - angular&indistinct	hypoechoic	combined	yes	in a mass	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
28	28	case028.png	case028_tumor.png	NaN	0.0078125	58	heterogeneous: predominantly fat	no	not available	oval	circumscribed	hypoechoic	enhancement	no	no	no	Complex cyst / Non-simple cyst&Cyst filled with thick fluid	3	confirmed by follow-up care	not applicable	benign
29	29	case029.png	case029_tumor.png	NaN	0.005175983	78	heterogeneous: predominantly fat	no	not available	irregular	circumscribed	isoechoic	no	no	no	no	Dysplasia&Fibroadenoma	3	confirmed by follow-up care	not applicable	benign
30	30	case030.png	case030_tumor.png	NaN	0.006076389	35	heterogeneous: predominantly fibroglandular	no	no	oval	circumscribed	anechoic	no	no	no	no	Complex cyst / Non-simple cyst	3	confirmed by follow-up care	not applicable	benign
31	31	case031.png	case031_tumor.png	NaN	0.0078125	36	lactating	no	no	round	circumscribed	hypoechoic	no	yes	no	no	Cyst filled with thick fluid&Dysplasia&Fibroadenoma&Intraductal papilloma	4a	confirmed by biopsy	Lactating adenoma	benign
32	32	case032.png	case032_tumor.png	NaN	0.0078125	60	heterogeneous: predominantly fat	no	no	irregular	not circumscribed - microlobulated	hypoechoic	no	no	no	no	Suspicion of malignancy&Intraductal papilloma	4b	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
33	33	case033.png	case033_tumor.png	NaN	0.005882353	not available	heterogeneous: predominantly fat	no	no	oval	circumscribed	isoechoic	no	no	no	no	Suspicion of malignancy&Mammary duct ectasia&Intraductal papilloma	4a	confirmed by biopsy	Benign mammary dysplasia	benign
34	34	case034.png	case034_tumor.png	NaN	0.01078	60	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	no	yes	no	no	Suspicion of malignancy&Dysplasia&Fibroadenoma&Intraductal papilloma	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
35	35	case035.png	case035_tumor.png	NaN	0.006944444	56	heterogeneous: predominantly fat	no	personal history of breast cancer	irregular	not circumscribed - spiculated&angular	hypoechoic	shadowing	yes	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
36	36	case036.png	case036_tumor.png	case036_other1.png&case036_other2.png	0.0078125	63	heterogeneous: predominantly fibroglandular	no	nipple discharge	oval	circumscribed	hyperechoic	no	no	no	no	Duct filled with thick fluid&Mammary duct ectasia&Intraductal papilloma	4a	confirmed by biopsy	Intraductal papilloma	benign
37	37	case037.png	case037_tumor.png	NaN	0.005910165	60	heterogeneous: predominantly fat	palpable	not available	irregular	circumscribed	hypoechoic	shadowing	no	in a mass	no	Fibroadenoma&Isolated calcifications	4a	confirmed by biopsy	Fibroadenoma	benign
38	38	case038.png	case038_tumor.png	case038_other1.png	0.005181347	not available	heterogeneous: predominantly fibroglandular	no	not available	oval	circumscribed	hypoechoic	no	no	no	no	Cyst filled with thick fluid&Fibroadenoma&Silicone implant	3	confirmed by follow-up care	not applicable	benign
39	39	case039.png	case039_tumor.png	NaN	0.0078125	35	homogeneous: fibroglandular	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Dysplasia&Fibroadenoma&Adenosis	3	confirmed by biopsy	Fibrosclerosis	benign
40	40	case040.png	case040_tumor.png	NaN	0.005175983	43	heterogeneous: predominantly fibroglandular	not available	not available	oval	circumscribed	complex cystic/solid	enhancement	no	in a mass	no	Dysplasia&Fibroadenoma	4a	confirmed by biopsy	Fibroadenoma	benign
41	41	case041.png	case041_tumor.png	NaN	0.005910165	not available	homogeneous: fibroglandular	no	not available	irregular	circumscribed	isoechoic	no	no	no	no	Dysplasia	4a	confirmed by biopsy	Benign mammary dysplasia	benign
42	42	case042.png	case042_tumor.png	NaN	0.006688963	not available	homogeneous: fibroglandular	no	nipple discharge	round	circumscribed	isoechoic	no	no	no	no	Suspicion of malignancy&Intraductal papilloma	4b	confirmed by biopsy	Intraductal papilloma	benign
43	43	case043.png	case043_tumor.png	NaN	0.0078125	25	homogeneous: fibroglandular	no	no	round	circumscribed	hypoechoic	combined	no	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4b	confirmed by biopsy	Fibroadenoma	benign
44	44	case044.png	case044_tumor.png	NaN	0.005882353	not available	heterogeneous: predominantly fibroglandular	no	no	irregular	not circumscribed - angular	anechoic	no	no	no	no	Suspicion of malignancy&Complex cyst / Non-simple cyst	4b	confirmed by biopsy	Benign mammary dysplasia	benign
45	45	case045.png	NaN	NaN	0.007525084	32	lactating&homogeneous: fibroglandular	not available	not available	not applicable	not applicable	not applicable	not applicable	not applicable	not applicable	no	not applicable	1	not applicable	not applicable	normal
46	46	case046.png	case046_tumor.png	NaN	0.009197324	73	homogeneous: fat	no	not available	irregular	not circumscribed - indistinct	hypoechoic	no	yes	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
47	47	case047.png	case047_tumor.png	NaN	0.0078125	55	heterogeneous: predominantly fibroglandular	no	no	irregular	not circumscribed - spiculated&microlobulated&indistinct	hypoechoic	shadowing	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Pseudoangiomatous stromal hyperplasia (PASH)	benign
48	48	case048.png	case048_tumor.png	NaN	0.00726979	not available	heterogeneous: predominantly fibroglandular	no	not available	round	circumscribed	anechoic	enhancement	no	no	no	Simple cyst	2	confirmed by follow-up care	not applicable	benign
49	49	case049.png	case049_tumor.png	NaN	0.0078125	60	heterogeneous: predominantly fat	no	not available	oval	circumscribed	complex cystic/solid	no	no	no	no	Cyst filled with thick fluid&Dysplasia&Duct filled with thick fluid&Mammary duct ectasia	2	confirmed by follow-up care	not applicable	benign
50	50	case050.png	case050_tumor.png	NaN	0.01078	55	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	no	yes	no	no	Suspicion of malignancy&Dysplasia&Fibroadenoma&Intraductal papilloma	5	confirmed by biopsy	Invasive lobular carcinoma	malignant
51	51	case051.png	case051_tumor.png	NaN	0.0078125	31	homogeneous: fibroglandular	no	not available	oval	circumscribed	complex cystic/solid	no	no	no	no	Complex cyst / Non-simple cyst&Dysplasia&Hamartoma	4a	confirmed by biopsy	Complex sclerosing lesion	benign
52	52	case052.png	case052_tumor.png	NaN	0.006462036	not available	lactating&heterogeneous: predominantly fibroglandular	not available	no	irregular	circumscribed	hypoechoic	no	no	no	no	Fibroadenoma	3	confirmed by follow-up care	not applicable	benign
53	53	case053.png	case053_tumor.png	NaN	0.0078125	44	heterogeneous: predominantly fibroglandular	no	HRT/hormonal contraception	irregular	not circumscribed - spiculated&indistinct	hypoechoic	shadowing	no	in a mass	no	Suspicion of malignancy&Dysplasia	4b	confirmed by biopsy	Invasive lobular carcinoma&Lobular carcinoma in situ (LCIS)	malignant
54	54	case054.png	case054_tumor.png	NaN	0.005181347	38	heterogeneous: predominantly fat	no	not available	irregular	circumscribed	isoechoic	no	no	no	no	Dysplasia	3	confirmed by biopsy	Fibroadenoma	benign
55	55	case055.png	case055_tumor.png	NaN	0.0078125	65	heterogeneous: predominantly fibroglandular	no	no	irregular	not circumscribed - angular&indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy	4b	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
56	56	case056.png	case056_tumor.png	NaN	0.01078	32	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	enhancement	no	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4a	confirmed by biopsy	Phyllodes tumor	benign
57	57	case057.png	case057_tumor.png	NaN	0.00726979	not available	homogeneous: fat	no	not available	irregular	circumscribed	anechoic	no	no	no	no	Simple cyst	2	confirmed by follow-up care	not applicable	benign
58	58	case058.png	case058_tumor.png	NaN	0.00924	59	not available	not available	not available	irregular	not circumscribed - angular&microlobulated&indistinct	hypoechoic	enhancement	no	indefinable	no	Suspicion of malignancy&Dysplasia&Fibroadenoma&Intraductal papilloma	4b	confirmed by biopsy	Ductal carcinoma in situ (DCIS)	malignant
59	59	case059.png	case059_tumor.png	NaN	0.006944444	77	heterogeneous: predominantly fat	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Dysplasia&Fibroadenoma&Duct filled with thick fluid&Intraductal papilloma	4a	confirmed by biopsy	Lobular carcinoma in situ (LCIS)	benign
60	60	case060.png	case060_tumor.png	NaN	0.006944444	71	heterogeneous: predominantly fat	palpable	no	irregular	not circumscribed - indistinct	hypoechoic	shadowing	yes	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
61	61	case061.png	NaN	NaN	0.005902192	not available	lactating&homogeneous: fibroglandular	no	not available	not applicable	not applicable	not applicable	not applicable	not applicable	not applicable	no	not applicable	1	not applicable	not applicable	normal
62	62	case062.png	case062_tumor.png	NaN	0.005208333	45	homogeneous: fibroglandular	no	no	irregular	not circumscribed - indistinct	hypoechoic	shadowing	no	in a mass	no	Suspicion of malignancy&Dysplasia	4b	confirmed by biopsy	Fibrosclerosis	benign
63	63	case063.png	case063_tumor.png	NaN	0.01078	64	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	no	yes	no	no	Suspicion of malignancy&Dysplasia&Fibroadenoma&Intraductal papilloma	5	confirmed by biopsy	Invasive lobular carcinoma	malignant
64	64	case064.png	case064_tumor.png	NaN	0.0078125	38	homogeneous: fibroglandular	no	HRT/hormonal contraception	oval	circumscribed	anechoic	enhancement	no	no	no	Complex cyst / Non-simple cyst	2	confirmed by follow-up care	not applicable	benign
65	65	case065.png	case065_tumor.png	NaN	0.006944444	85	homogeneous: fat	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Cyst filled with thick fluid&Intramammary lymph node	2	confirmed by follow-up care	not applicable	benign
66	66	case066.png	case066_tumor.png	NaN	0.00924	48	not available	not available	not available	irregular	not circumscribed - indistinct	heterogeneous	no	no	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
67	67	case067.png	case067_tumor.png	NaN	0.006944444	72	not available	no	no	irregular	not circumscribed - microlobulated&indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Cribriform carcinoma	malignant
68	68	case068.png	case068_tumor.png	NaN	0.006944444	35	homogeneous: fibroglandular	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Fibroadenoma	3	confirmed by biopsy	Fibroadenoma	benign
69	69	case069.png	case069_tumor.png	NaN	0.0078125	54	heterogeneous: predominantly fat	no	not available	oval	circumscribed	heterogeneous	enhancement	no	no	no	Complex cyst / Non-simple cyst&Cyst filled with thick fluid&Fibroadenoma&Intraductal papilloma	4a	confirmed by biopsy	Benign mammary dysplasia	benign
70	70	case070.png	case070_tumor.png	NaN	0.006076389	47	heterogeneous: predominantly fibroglandular	no	family history of breast/ovarian cancer	irregular	not circumscribed - indistinct	hypoechoic	shadowing	yes	no	no	Suspicion of malignancy&Dysplasia	4c	confirmed by biopsy	Fibrosclerosis	benign
71	71	case071.png	case071_tumor.png	NaN	0.006944444	62	heterogeneous: predominantly fibroglandular	no	HRT/hormonal contraception	oval	circumscribed	heterogeneous	no	no	no	no	Hamartoma	4a	confirmed by biopsy	Hamartoma	benign
72	72	case072.png	case072_tumor.png	NaN	0.00924	69	not available	not available	not available	irregular	circumscribed	hypoechoic	no	no	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4b	confirmed by biopsy	Ductal carcinoma in situ (DCIS)	malignant
73	73	case073.png	case073_tumor.png	NaN	0.0078125	55	heterogeneous: predominantly fat	breast scar&skin retraction	personal history of breast cancer&family history of breast/ovarian cancer	irregular	not circumscribed - indistinct	hypoechoic	shadowing	no	indefinable	yes	Hematoma&Breast scar (surgery)	2	confirmed by follow-up care	not applicable	benign
74	74	case074.png	case074_tumor.png	NaN	0.005181347	66	not available	no	not available	irregular	circumscribed	hypoechoic	no	no	no	no	Cyst filled with thick fluid&Dysplasia&Duct filled with thick fluid&Intraductal papilloma	4a	confirmed by biopsy	Fibrosclerosis	benign
75	75	case075.png	case075_tumor.png	NaN	0.01078	65	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	shadowing	yes	no	no	Suspicion of malignancy&Dysplasia&Fibroadenoma&Intraductal papilloma	4c	confirmed by biopsy	Invasive lobular carcinoma	malignant
76	76	case076.png	case076_tumor.png	NaN	0.0078125	59	heterogeneous: predominantly fibroglandular	nipple retraction&palpable	family history of breast/ovarian cancer	irregular	not circumscribed - spiculated&microlobulated&indistinct	hypoechoic	no	yes	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
77	77	case077.png	case077_tumor.png	NaN	0.0078125	49	not available	palpable	no	oval	circumscribed	hypoechoic	no	no	no	no	Suspicion of malignancy&Fibroadenoma&Phyllodes tumor	4a	confirmed by biopsy	Fibroadenoma&Phyllodes tumor	benign
78	78	case078.png	case078_tumor.png	NaN	0.00924	23	not available	not available	not available	oval	circumscribed	isoechoic	enhancement	no	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	3	confirmed by biopsy	Phyllodes tumor	benign
79	79	case079.png	case079_tumor.png	NaN	0.0078125	44	homogeneous: fibroglandular	palpable	no	irregular	not circumscribed - spiculated&indistinct	hypoechoic	shadowing	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive lobular carcinoma	malignant
80	80	case080.png	case080_tumor.png	NaN	0.006462036	21	heterogeneous: predominantly fibroglandular	no	not available	oval	circumscribed	hypoechoic	enhancement	no	no	no	Cyst filled with thick fluid	2	confirmed by follow-up care	not applicable	benign
81	81	case081.png	case081_tumor.png	NaN	0.0078125	52	heterogeneous: predominantly fat	no	not available	oval	circumscribed	hypoechoic	no	no	no	no	Fibroadenoma&Intraductal papilloma	4a	confirmed by biopsy	Fibrocystic change	benign
82	82	case082.png	case082_tumor.png	NaN	0.0078125	43	not available	palpable	HRT/hormonal contraception	irregular	not circumscribed - spiculated&indistinct	hypoechoic	no	yes	no	no	Suspicion of malignancy&Fibroadenoma	4c	confirmed by biopsy	Mucinous carcinoma	malignant
83	83	case083.png	case083_tumor.png	NaN	0.005902192	41	heterogeneous: predominantly fibroglandular	not available	no	irregular	circumscribed	heterogeneous	no	no	no	no	Dysplasia	4a	confirmed by biopsy	Benign mammary dysplasia	benign
84	84	case084.png	case084_tumor.png	NaN	0.01078	57	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy&Dysplasia&Fibroadenoma&Intraductal papilloma	4b	confirmed by biopsy	Benign mammary dysplasia	benign
85	85	case085.png	case085_tumor.png	case085_other1.png&case085_other2.png	0.005190311	57	heterogeneous: predominantly fat	no	not available	oval	circumscribed	complex cystic/solid	no	no	no	no	Duct filled with thick fluid&Mammary duct ectasia	3	confirmed by follow-up care	not applicable	benign
86	86	case086.png	case086_tumor.png	NaN	0.01078	78	not available	not available	not available	irregular	not circumscribed - indistinct	heterogeneous	shadowing	yes	no	no	Suspicion of malignancy&Dysplasia&Fibroadenoma&Intraductal papilloma	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
87	87	case087.png	case087_tumor.png	NaN	0.0078125	76	heterogeneous: predominantly fat	palpable	HRT/hormonal contraception	irregular	not circumscribed - indistinct	hypoechoic	no	yes	no	no	Suspicion of malignancy&Mastitis	4b	confirmed by biopsy	Ductal carcinoma in situ (DCIS)&Invasive carcinoma of no special type (NST)	malignant
88	88	case088.png	case088_tumor.png	NaN	0.005181347	not available	heterogeneous: predominantly fat	palpable	no	irregular	not circumscribed - microlobulated	hypoechoic	enhancement	no	no	no	Suspicion of malignancy&Intraductal papilloma	4b	confirmed by biopsy	Tubular carcinoma	malignant
89	89	case089.png	case089_tumor.png	NaN	0.0078125	43	heterogeneous: predominantly fibroglandular	no	family history of breast/ovarian cancer	irregular	not circumscribed - spiculated	hypoechoic	no	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
90	90	case090.png	case090_tumor.png	NaN	0.0078125	76	homogeneous: fat	no	no	irregular	not circumscribed - angular&indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
91	91	case091.png	case091_tumor.png	NaN	0.006944444	74	heterogeneous: predominantly fat	no	family history of breast/ovarian cancer	oval	circumscribed	heterogeneous	no	no	no	no	Complex cyst / Non-simple cyst&Fibroadenoma	3	confirmed by follow-up care	not applicable	benign
92	92	case092.png	case092_tumor.png	case092_other1.png	0.005910165	not available	homogeneous: fibroglandular	no	not available	irregular	not circumscribed - indistinct	heterogeneous	no	no	in a mass	no	Suspicion of malignancy&Dysplasia&Silicone implant	4b	confirmed by biopsy	Benign mammary dysplasia	benign
93	93	case093.png	case093_tumor.png	NaN	0.0078125	67	heterogeneous: predominantly fat	no	no	oval	circumscribed	isoechoic	no	no	no	no	Fibroadenoma&Hamartoma	4a	confirmed by biopsy	Pseudoangiomatous stromal hyperplasia (PASH)	benign
94	94	case094.png	case094_tumor.png	NaN	0.0078125	48	heterogeneous: predominantly fibroglandular	palpable	no	irregular	not circumscribed - angular	hypoechoic	no	no	in a mass	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)&Ductal carcinoma in situ (DCIS)	malignant
95	95	case095.png	case095_tumor.png	NaN	0.006944444	68	heterogeneous: predominantly fat	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Complex cyst / Non-simple cyst&Fibroadenoma	3	confirmed by follow-up care	not applicable	benign
96	96	case096.png	case096_tumor.png	NaN	0.006944444	76	heterogeneous: predominantly fat	no	not available	oval	circumscribed	hypoechoic	shadowing	no	in a mass	no	Complex cyst / Non-simple cyst&Cyst filled with thick fluid&Dysplasia&Fibroadenoma	3	confirmed by follow-up care	not applicable	benign
97	97	case097.png	case097_tumor.png	NaN	0.005882353	not available	heterogeneous: predominantly fibroglandular	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Fibroadenoma&Cyst filled with thick fluid	3	confirmed by follow-up care	not applicable	benign
98	98	case098.png	case098_tumor.png	NaN	0.006944444	37	homogeneous: fibroglandular	no	no	oval	circumscribed	heterogeneous	no	no	no	no	Complex cyst / Non-simple cyst&Fibroadenoma	3	confirmed by follow-up care	not applicable	benign
99	99	case099.png	case099_tumor.png	NaN	0.0078125	62	homogeneous: fat	no	no	irregular	not circumscribed - spiculated	hypoechoic	no	no	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
100	100	case100.png	case100_tumor.png	NaN	0.0078125	57	heterogeneous: predominantly fibroglandular	no	no	oval	circumscribed	heterogeneous	shadowing	no	no	no	Dysplasia	3	confirmed by biopsy	Benign mammary dysplasia	benign
101	101	case101.png	case101_tumor.png	NaN	0.0078125	51	heterogeneous: predominantly fibroglandular	no	no	irregular	not circumscribed - indistinct	heterogeneous	shadowing	no	in a mass	no	Suspicion of malignancy&Dysplasia&Intraductal papilloma	4c	confirmed by biopsy	Mucinous carcinoma	malignant
102	102	case102.png	case102_tumor.png	NaN	0.01078	41	not available	not available	not available	irregular	not circumscribed - angular&indistinct	heterogeneous	shadowing	yes	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)&Ductal carcinoma in situ (DCIS)	malignant
103	103	case103.png	case103_tumor.png	NaN	0.0078125	65	heterogeneous: predominantly fat	nipple retraction	no	irregular	not circumscribed - indistinct	hypoechoic	shadowing	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
104	104	case104.png	case104_tumor.png	NaN	0.0078125	50	heterogeneous: predominantly fat	no	no	irregular	not circumscribed - microlobulated&indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy&Dysplasia&Intraductal papilloma&Hematoma	4b	confirmed by biopsy	Fibrosclerosis	benign
105	105	case105.png	case105_tumor.png	NaN	0.0078125	63	heterogeneous: predominantly fat	palpable	not available	irregular	not circumscribed - spiculated&indistinct	hypoechoic	shadowing	yes	in a mass	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
106	106	case106.png	case106_tumor.png	NaN	0.0078125	69	heterogeneous: predominantly fat	skin retraction&palpable	no	irregular	not circumscribed - angular&microlobulated	hypoechoic	shadowing	no	no	no	Suspicion of malignancy	5	confirmed by biopsy	Cribriform carcinoma	malignant
107	107	case107.png	case107_tumor.png	NaN	0.01078	70	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy&Dysplasia&Fibroadenoma&Intraductal papilloma	4b	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
108	108	case108.png	case108_tumor.png	NaN	0.005208333	37	homogeneous: fibroglandular	no	not available	oval	circumscribed	heterogeneous	no	no	no	no	Intramammary lymph node	2	confirmed by follow-up care	not applicable	benign
109	109	case109.png	case109_tumor.png	NaN	0.0078125	62	homogeneous: fat	palpable	no	irregular	not circumscribed - spiculated&angular&microlobulated&indistinct	hypoechoic	shadowing	yes	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive micropapillary carcinoma	malignant
110	110	case110.png	case110_tumor.png	NaN	0.0078125	48	homogeneous: fibroglandular	no	family history of breast/ovarian cancer&HRT/hormonal contraception	oval	circumscribed	anechoic	enhancement	no	no	no	Complex cyst / Non-simple cyst&Cyst filled with thick fluid	2	confirmed by follow-up care	not applicable	benign
111	111	case111.png	case111_tumor.png	NaN	0.0078125	67	heterogeneous: predominantly fat	no	no	oval	circumscribed	heterogeneous	no	no	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4a	confirmed by biopsy	Invasive lobular carcinoma	malignant
112	112	case112.png	case112_tumor.png	NaN	0.0078125	64	heterogeneous: predominantly fibroglandular	no	no	irregular	not circumscribed - microlobulated	hypoechoic	no	no	no	no	Suspicion of malignancy&Dysplasia&Duct filled with thick fluid&Mammary duct ectasia&Intraductal papilloma	4b	confirmed by biopsy	Invasive micropapillary carcinoma	malignant
113	113	case113.png	case113_tumor.png	NaN	0.00726979	not available	heterogeneous: predominantly fat	palpable	no	irregular	not circumscribed - spiculated&indistinct	hypoechoic	shadowing	yes	no	yes	Suspicion of malignancy	4c	confirmed by biopsy	Invasive lobular carcinoma	malignant
114	114	case114.png	case114_tumor.png	NaN	0.0078125	59	heterogeneous: predominantly fat	no	no	oval	not circumscribed - indistinct	hypoechoic	no	no	in a mass	no	Suspicion of malignancy&Cyst filled with thick fluid&Dysplasia&Fibroadenoma	4b	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
115	115	case115.png	case115_tumor.png	NaN	0.007525084	56	homogeneous: fat	no	not available	irregular	not circumscribed - indistinct	heterogeneous	no	yes	no	no	Suspicion of malignancy&Dysplasia	5	confirmed by biopsy	Fat necrosis	benign
116	116	case116.png	case116_tumor.png	NaN	0.006076389	47	heterogeneous: predominantly fat	palpable	family history of breast/ovarian cancer	oval	not circumscribed - indistinct	heterogeneous	no	no	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4b	confirmed by biopsy	Benign mammary dysplasia	benign
117	117	case117.png	case117_tumor.png	NaN	0.0078125	52	heterogeneous: predominantly fibroglandular	peau d`orange&palpable	family history of breast/ovarian cancer	irregular	not circumscribed - microlobulated	heterogeneous	no	no	no	yes	Suspicion of malignancy	4c	confirmed by biopsy	Lymphoma	malignant
118	118	case118.png	case118_tumor.png	NaN	0.0078125	51	heterogeneous: predominantly fibroglandular	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Complex cyst / Non-simple cyst&Cyst filled with thick fluid&Fibroadenoma	3	confirmed by follow-up care	not applicable	benign
119	119	case119.png	case119_tumor.png	NaN	0.006076389	33	homogeneous: fibroglandular	palpable	no	irregular	not circumscribed - spiculated&microlobulated&indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Usual ductal hyperplasia (UDH)	benign
120	120	case120.png	case120_tumor.png	NaN	0.006076389	42	homogeneous: fibroglandular	palpable	no	irregular	not circumscribed - indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy&Fibroadenoma	4b	confirmed by biopsy	Intraductal papilloma&Usual ductal hyperplasia (UDH)&Adenosis	benign
121	121	case121.png	case121_tumor.png	NaN	0.0078125	68	heterogeneous: predominantly fat	no	no	round	not circumscribed - microlobulated&indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
122	122	case122.png	case122_tumor.png	NaN	0.0078125	39	heterogeneous: predominantly fibroglandular	no	no	oval	not circumscribed - microlobulated&indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy&Fibroadenoma	4b	confirmed by biopsy	Benign mammary dysplasia	benign
123	123	case123.png	case123_tumor.png	NaN	0.005081301	not available	homogeneous: fat	no	no	oval	circumscribed	heterogeneous	no	no	no	no	Suspicion of malignancy&Complex cyst / Non-simple cyst&Dysplasia&Fibroadenoma&Mammary duct ectasia&Intraductal papilloma	4b	confirmed by biopsy	Benign mammary dysplasia	benign
124	124	case124.png	case124_tumor.png	NaN	0.005208333	27	homogeneous: fibroglandular	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Fibroadenoma	2	confirmed by follow-up care	not applicable	benign
125	125	case125.png	case125_tumor.png	NaN	0.0078125	87	heterogeneous: predominantly fat	palpable	no	irregular	not circumscribed - spiculated&indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive lobular carcinoma	malignant
126	126	case126.png	case126_tumor.png	NaN	0.01078	21	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	enhancement	no	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4a	confirmed by biopsy	Fibroadenoma	benign
127	127	case127.png	case127_tumor.png	NaN	0.006076389	66	heterogeneous: predominantly fibroglandular	no	not available	irregular	not circumscribed - spiculated&indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy&Dysplasia	4b	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
128	128	case128.png	case128_tumor.png	NaN	0.00924	63	not available	not available	not available	irregular	not circumscribed - angular&indistinct	heterogeneous	enhancement	yes	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4b	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
129	129	case129.png	case129_tumor.png	NaN	0.0078125	68	heterogeneous: predominantly fat	not available	not available	irregular	not circumscribed - angular&microlobulated&indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy	5	confirmed by biopsy	Usual ductal hyperplasia (UDH)&Fibrosclerosis	benign
130	130	case130.png	case130_tumor.png	NaN	0.0078125	68	homogeneous: fat	no	no	irregular	not circumscribed - angular&indistinct	hypoechoic	no	yes	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
131	131	case131.png	case131_tumor.png	NaN	0.005902192	not available	not available	no	no	irregular	circumscribed	heterogeneous	no	no	no	no	Suspicion of malignancy&Dysplasia&Fibroadenoma	4b	confirmed by biopsy	Benign mammary dysplasia	benign
132	132	case132.png	case132_tumor.png	NaN	0.006944444	70	heterogeneous: predominantly fibroglandular	no	no	oval	not circumscribed - indistinct	hypoechoic	shadowing	no	no	no	Suspicion of malignancy&Cyst filled with thick fluid&Dysplasia&Fibroadenoma	4b	confirmed by biopsy	Ductal carcinoma in situ (DCIS)	malignant
133	133	case133.png	case133_tumor.png	NaN	0.008680556	47	heterogeneous: predominantly fibroglandular	palpable	no	irregular	not circumscribed - angular&indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive micropapillary carcinoma	malignant
134	134	case134.png	case134_tumor.png	NaN	0.005902192	not available	not available	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Dysplasia	4a	confirmed by biopsy	Benign mammary dysplasia	benign
135	135	case135.png	case135_tumor.png	NaN	0.01078	43	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	enhancement	no	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4b	confirmed by biopsy	Fibroadenoma	benign
136	136	case136.png	case136_tumor.png	NaN	0.006688963	not available	heterogeneous: predominantly fat	no	not available	round	circumscribed	hyperechoic	no	no	no	no	Lipoma	2	confirmed by follow-up care	not applicable	benign
137	137	case137.png	case137_tumor.png	NaN	0.006076389	58	heterogeneous: predominantly fat	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Fibroadenoma	3	confirmed by follow-up care	not applicable	benign
138	138	case138.png	case138_tumor.png	NaN	0.0078125	59	homogeneous: fat	breast scar	personal history of breast cancer	irregular	not circumscribed - spiculated&indistinct	hypoechoic	shadowing	no	no	yes	Breast scar (surgery)	2	confirmed by follow-up care	not applicable	benign
139	139	case139.png	case139_tumor.png	NaN	0.006944444	26	homogeneous: fibroglandular	no	no	oval	circumscribed	complex cystic/solid	no	no	no	no	Fibroadenoma	4a	confirmed by biopsy	Fibroadenoma	benign
140	140	case140.png	case140_tumor.png	case140_other1.png&case140_other2.png&case140_other3.png&case140_other4.png	0.006688963	57	heterogeneous: predominantly fat	no	not available	oval	circumscribed	anechoic	no	no	no	no	Mammary duct ectasia	2	confirmed by follow-up care	not applicable	benign
141	141	case141.png	case141_tumor.png	NaN	0.006462036	not available	heterogeneous: predominantly fat	palpable	no	irregular	not circumscribed - spiculated&angular&indistinct	anechoic	shadowing	no	no	yes	Suspicion of malignancy&Dysplasia&Breast scar (surgery)	4c	confirmed by biopsy	Benign mammary dysplasia	benign
142	142	case142.png	case142_tumor.png	NaN	0.006944444	87	homogeneous: fat	no	no	oval	circumscribed	heterogeneous	no	no	no	no	Complex cyst / Non-simple cyst&Cyst filled with thick fluid&Intraductal papilloma	4a	confirmed by biopsy	Simple cyst	benign
143	143	case143.png	case143_tumor.png	NaN	0.006944444	70	heterogeneous: predominantly fat	no	no	irregular	not circumscribed - spiculated&indistinct	heterogeneous	no	no	in a mass	no	Suspicion of malignancy&Dysplasia	4b	confirmed by biopsy	Intraductal papilloma	benign
144	144	case144.png	case144_tumor.png	NaN	0.013888889	76	heterogeneous: predominantly fat	warmth&palpable	no	oval	not circumscribed - indistinct	complex cystic/solid	no	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
145	145	case145.png	case145_tumor.png	NaN	0.006688963	71	heterogeneous: predominantly fat	no	not available	irregular	not circumscribed - indistinct	heterogeneous	no	no	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
146	146	case146.png	case146_tumor.png	NaN	0.01078	35	not available	not available	not available	irregular	not circumscribed - indistinct	isoechoic	combined	no	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4a	confirmed by biopsy	Fibroadenoma	benign
147	147	case147.png	case147_tumor.png	NaN	0.0078125	72	homogeneous: fat	redness&warmth&palpable	no	irregular	not circumscribed - microlobulated&indistinct	hypoechoic	shadowing	yes	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
148	148	case148.png	case148_tumor.png	NaN	0.01078	69	not available	not available	not available	irregular	not circumscribed - angular&indistinct	hypoechoic	enhancement	yes	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
149	149	case149.png	case149_tumor.png	NaN	0.006944444	65	heterogeneous: predominantly fat	skin retraction&palpable	no	irregular	not circumscribed - spiculated&angular&microlobulated&indistinct	hypoechoic	shadowing	yes	no	yes	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
150	150	case150.png	case150_tumor.png	NaN	0.01078	69	not available	not available	not available	irregular	not circumscribed - spiculated&angular&indistinct	hypoechoic	combined	yes	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)&Ductal carcinoma in situ (DCIS)	malignant
151	151	case151.png	case151_tumor.png	case151_other1.png&case151_other2.png	0.006944444	43	heterogeneous: predominantly fibroglandular	no	nipple discharge&family history of breast/ovarian cancer	oval	circumscribed	hyperechoic	no	no	no	no	Duct filled with thick fluid&Mammary duct ectasia&Intraductal papilloma	4a	confirmed by biopsy	Intraductal papilloma	benign
152	152	case152.png	case152_tumor.png	NaN	0.006076389	31	homogeneous: fibroglandular	palpable	no	oval	not circumscribed - indistinct	hyperechoic	no	no	no	no	Suspicion of malignancy&Fibroadenoma	4b	confirmed by biopsy	Fibroadenoma	benign
153	153	case153.png	case153_tumor.png	NaN	0.0078125	52	heterogeneous: predominantly fat	palpable	no	irregular	not circumscribed - microlobulated&indistinct	heterogeneous	no	no	in a mass	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
154	154	case154.png	case154_tumor.png	NaN	0.006076389	66	heterogeneous: predominantly fat	palpable	not available	irregular	not circumscribed - spiculated&angular&microlobulated&indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
155	155	case155.png	case155_tumor.png	NaN	0.01078	29	not available	not available	not available	oval	circumscribed	heterogeneous	enhancement	no	no	no	Suspicion of malignancy&Dysplasia&Fibroadenoma&Intraductal papilloma&Hamartoma	4a	confirmed by biopsy	Benign mammary dysplasia	benign
156	156	case156.png	case156_tumor.png	NaN	0.009197324	45	heterogeneous: predominantly fat	no	not available	irregular	circumscribed	anechoic	enhancement	no	no	no	Complex cyst / Non-simple cyst	2	confirmed by follow-up care	not applicable	benign
157	157	case157.png	case157_tumor.png	NaN	0.006688963	not available	heterogeneous: predominantly fibroglandular	redness&warmth&palpable	not available	irregular	circumscribed	heterogeneous	no	yes	no	yes	Suspicion of malignancy&Mastitis&Abscess&Hematoma&Breast scar (surgery)	4b	confirmed by biopsy	Mastitis	benign
158	158	case158.png	case158_tumor.png	NaN	0.0078125	37	heterogeneous: predominantly fibroglandular	no	HRT/hormonal contraception	irregular	not circumscribed - spiculated&microlobulated&indistinct	hypoechoic	no	yes	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
159	159	case159.png	case159_tumor.png	NaN	0.006944444	50	heterogeneous: predominantly fibroglandular	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Complex cyst / Non-simple cyst&Cyst filled with thick fluid&Fibroadenoma	3	confirmed by biopsy	Fibroadenoma	benign
160	160	case160.png	case160_tumor.png	NaN	0.006462036	not available	heterogeneous: predominantly fat	not available	not available	irregular	not circumscribed - angular&indistinct	heterogeneous	combined	no	in a mass	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
161	161	case161.png	case161_tumor.png	NaN	0.0078125	61	heterogeneous: predominantly fat	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Fibroadenoma&Intraductal papilloma	4a	confirmed by biopsy	Fibroadenoma	benign
162	162	case162.png	case162_tumor.png	NaN	0.0078125	32	lactating&homogeneous: fibroglandular	palpable	family history of breast/ovarian cancer	irregular	not circumscribed - indistinct	heterogeneous	shadowing	yes	no	no	Suspicion of malignancy&Mastitis	4b	confirmed by biopsy	Mastitis	benign
163	163	case163.png	case163_tumor.png	NaN	0.00924	51	not available	not available	not available	oval	circumscribed	isoechoic	no	no	no	no	Suspicion of malignancy&Dysplasia&Fibroadenoma&Intraductal papilloma	3	confirmed by biopsy	Fibroadenoma	benign
164	164	case164.png	case164_tumor.png	NaN	0.0078125	59	heterogeneous: predominantly fat	palpable	no	irregular	not circumscribed - spiculated	heterogeneous	shadowing	no	in a mass	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
165	165	case165.png	case165_tumor.png	NaN	0.01078	42	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	enhancement	no	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4b	confirmed by biopsy	Fibroadenoma	benign
166	166	case166.png	case166_tumor.png	NaN	0.008361204	not available	not available	no	no	irregular	not circumscribed - angular&indistinct	heterogeneous	no	no	no	no	Suspicion of malignancy&Dysplasia	4c	confirmed by biopsy	Benign mammary dysplasia	benign
167	167	case167.png	case167_tumor.png	NaN	0.006944444	78	heterogeneous: predominantly fat	no	no	oval	circumscribed	hyperechoic	no	no	no	no	Lipoma&Hemangioma	2	confirmed by follow-up care	not applicable	benign
168	168	case168.png	case168_tumor.png	NaN	0.0078125	48	heterogeneous: predominantly fibroglandular	no	not available	oval	circumscribed	complex cystic/solid	no	no	no	no	Dysplasia&Fibroadenoma&Hamartoma	4a	confirmed by biopsy	Usual ductal hyperplasia (UDH)&Fibrocystic change	benign
169	169	case169.png	case169_tumor.png	NaN	0.0078125	75	homogeneous: fat	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Intramammary lymph node	2	confirmed by follow-up care	not applicable	benign
170	170	case170.png	case170_tumor.png	NaN	0.005910165	not available	heterogeneous: predominantly fat	no	no	irregular	not circumscribed - angular&indistinct	hypoechoic	combined	no	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
171	171	case171.png	case171_tumor.png	NaN	0.0078125	46	heterogeneous: predominantly fibroglandular	no	no	oval	circumscribed	hypoechoic	shadowing	no	no	no	Complex cyst / Non-simple cyst&Cyst filled with thick fluid&Fibroadenoma&Intraductal papilloma	4a	confirmed by biopsy	Fibroadenoma	benign
172	172	case172.png	case172_tumor.png	NaN	0.0078125	58	heterogeneous: predominantly fibroglandular	palpable	no	irregular	not circumscribed - angular&indistinct	hypoechoic	no	yes	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)&Sebaceous carcinoma	malignant
173	173	case173.png	case173_tumor.png	NaN	0.010416667	67	homogeneous: fat	no	no	irregular	not circumscribed - indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
174	174	case174.png	case174_tumor.png	NaN	0.0078125	40	homogeneous: fibroglandular	palpable	no	irregular	not circumscribed - indistinct	heterogeneous	no	no	no	no	Suspicion of malignancy&Intraductal papilloma	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
175	175	case175.png	case175_tumor.png	NaN	0.008680556	53	heterogeneous: predominantly fat	redness&warmth	nipple discharge	irregular	not circumscribed - indistinct	hypoechoic	no	no	no	yes	Mastitis	2	confirmed by follow-up care	not applicable	benign
176	176	case176.png	case176_tumor.png	NaN	0.008680556	43	heterogeneous: predominantly fibroglandular	palpable	HRT/hormonal contraception	irregular	not circumscribed - spiculated&angular&microlobulated&indistinct	hypoechoic	shadowing	yes	no	no	Suspicion of malignancy	5	confirmed by biopsy	Metaplastic carcinoma	malignant
177	177	case177.png	case177_tumor.png	NaN	0.005910165	57	heterogeneous: predominantly fat	no	not available	round	circumscribed	hypoechoic	no	no	no	no	Cyst filled with thick fluid	3	confirmed by follow-up care	not applicable	benign
178	178	case178.png	case178_tumor.png	NaN	0.011658031	61	heterogeneous: predominantly fat	no	not available	irregular	not circumscribed - angular	heterogeneous	no	no	in a mass	no	Suspicion of malignancy&Dysplasia	5	confirmed by biopsy	Fibrosclerosis	benign
179	179	case179.png	case179_tumor.png	NaN	0.006076389	45	heterogeneous: predominantly fibroglandular	no	family history of breast/ovarian cancer	irregular	not circumscribed - indistinct	hypoechoic	shadowing	yes	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Pseudoangiomatous stromal hyperplasia (PASH)	benign
180	180	case180.png	case180_tumor.png	NaN	0.006462036	not available	heterogeneous: predominantly fat	no	no	oval	circumscribed	hypoechoic	no	yes	no	no	Suspicion of malignancy&Complex cyst / Non-simple cyst&Dysplasia	4b	confirmed by biopsy	Benign mammary dysplasia	benign
181	181	case181.png	case181_tumor.png	NaN	0.0078125	47	heterogeneous: predominantly fibroglandular	no	not available	oval	circumscribed	hypoechoic	no	no	no	no	Complex cyst / Non-simple cyst&Cyst filled with thick fluid&Fibroadenoma	3	confirmed by follow-up care	not applicable	benign
182	182	case182.png	case182_tumor.png	NaN	0.0078125	41	heterogeneous: predominantly fibroglandular	palpable	no	round	not circumscribed - microlobulated	hypoechoic	no	no	no	no	Suspicion of malignancy&Dysplasia&Fibroadenoma&Intraductal papilloma&Phyllodes tumor	4b	confirmed by biopsy	Benign mammary dysplasia&Usual ductal hyperplasia (UDH)	benign
183	183	case183.png	case183_tumor.png	NaN	0.005208333	32	heterogeneous: predominantly fibroglandular	no	not available	oval	circumscribed	heterogeneous	no	no	no	no	Complex cyst / Non-simple cyst&Fibroadenoma	3	confirmed by biopsy	Fibroadenoma	benign
184	184	case184.png	case184_tumor.png	NaN	0.005181347	48	homogeneous: fibroglandular	no	not available	round	circumscribed	hypoechoic	no	no	no	no	Cyst filled with thick fluid	3	confirmed by follow-up care	not applicable	benign
185	185	case185.png	case185_tumor.png	NaN	0.01078	23	not available	not available	not available	oval	circumscribed	hypoechoic	no	no	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	3	confirmed by biopsy	Fibroadenoma	benign
186	186	case186.png	case186_tumor.png	NaN	0.009478673	43	homogeneous: fibroglandular	no	not available	irregular	circumscribed	hyperechoic	shadowing	no	no	no	Implant rupture&Silicone implant	2	confirmed by follow-up care	not applicable	benign
187	187	case187.png	case187_tumor.png	NaN	0.006462036	not available	heterogeneous: predominantly fat	no	no	irregular	not circumscribed - indistinct	heterogeneous	no	no	no	no	Suspicion of malignancy&Dysplasia	4c	confirmed by biopsy	Benign mammary dysplasia	benign
188	188	case188.png	case188_tumor.png	NaN	0.005208333	33	heterogeneous: predominantly fibroglandular	no	HRT/hormonal contraception	oval	circumscribed	hypoechoic	enhancement	no	no	no	Cyst filled with thick fluid	2	confirmed by follow-up care	not applicable	benign
189	189	case189.png	case189_tumor.png	NaN	0.0078125	57	heterogeneous: predominantly fat	no	no	oval	not circumscribed - indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy&Dysplasia&Intraductal papilloma	4b	confirmed by biopsy	Benign mammary dysplasia	benign
190	190	case190.png	case190_tumor.png	NaN	0.0078125	63	homogeneous: fibroglandular	palpable	no	irregular	not circumscribed - microlobulated	hypoechoic	no	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
191	191	case191.png	case191_tumor.png	NaN	0.005852843	57	heterogeneous: predominantly fat	no	not available	oval	circumscribed	anechoic	no	no	no	no	Mammary duct ectasia	2	confirmed by follow-up care	not applicable	benign
192	192	case192.png	case192_tumor.png	NaN	0.01078	35	not available	not available	not available	oval	circumscribed	hypoechoic	no	no	no	no	Suspicion of malignancy&Dysplasia&Fibroadenoma&Intraductal papilloma	3	confirmed by biopsy	Fibroadenoma	benign
193	193	case193.png	case193_tumor.png	NaN	0.005882353	not available	not available	no	no	round	not circumscribed - angular&indistinct	heterogeneous	no	no	no	yes	Suspicion of malignancy&Complex cyst / Non-simple cyst&Dysplasia	4c	confirmed by biopsy	Benign mammary dysplasia	benign
194	194	case194.png	case194_tumor.png	NaN	0.005882353	39	heterogeneous: predominantly fat	no	breast injury	round	circumscribed	hyperechoic	enhancement	no	no	no	Implant rupture&Silicone implant	2	confirmed by follow-up care	not applicable	benign
195	195	case195.png	case195_tumor.png	NaN	0.00726979	not available	homogeneous: fat	no	not available	irregular	not circumscribed - spiculated&angular	heterogeneous	no	yes	no	no	Suspicion of malignancy&Dysplasia	5	confirmed by biopsy	Invasive lobular carcinoma	malignant
196	196	case196.png	case196_tumor.png	NaN	0.005882353	not available	lactating&heterogeneous: predominantly fat	no	not available	oval	circumscribed	heterogeneous	no	no	no	no	Fibroadenoma&Lacteal cyst	3	confirmed by follow-up care	not applicable	benign
197	197	case197.png	case197_tumor.png	NaN	0.006076389	50	homogeneous: fibroglandular	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Dysplasia&Fibroadenoma	4a	confirmed by biopsy	Pseudoangiomatous stromal hyperplasia (PASH)	benign
198	198	case198.png	case198_tumor.png	NaN	0.006944444	53	heterogeneous: predominantly fat	palpable	no	irregular	not circumscribed - microlobulated&indistinct	hypoechoic	shadowing	yes	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
199	199	case199.png	case199_tumor.png	NaN	0.0078125	66	homogeneous: fat	no	no	irregular	not circumscribed - indistinct	hypoechoic	shadowing	yes	no	no	Suspicion of malignancy&Dysplasia	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)&Ductal carcinoma in situ (DCIS)	malignant
200	200	case200.png	case200_tumor.png	NaN	0.005208333	39	homogeneous: fibroglandular	palpable	HRT/hormonal contraception	oval	circumscribed	hypoechoic	no	no	no	no	Fibroadenoma	4a	confirmed by biopsy	Benign mammary dysplasia	benign
201	201	case201.png	case201_tumor.png	NaN	0.00726979	not available	heterogeneous: predominantly fat	not available	not available	irregular	circumscribed	hypoechoic	no	yes	no	no	Suspicion of malignancy	5	confirmed by biopsy	Intraductal papilloma	benign
202	202	case202.png	case202_tumor.png	NaN	0.004340278	21	homogeneous: fibroglandular	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Fibroadenoma	3	confirmed by biopsy	Fibroadenoma	benign
203	203	case203.png	case203_tumor.png	NaN	0.0078125	50	homogeneous: fibroglandular	no	HRT/hormonal contraception	oval	circumscribed	heterogeneous	no	no	no	no	Fibroadenoma&Hamartoma&Adenosis	4a	confirmed by biopsy	Pseudoangiomatous stromal hyperplasia (PASH)	benign
204	204	case204.png	case204_tumor.png	NaN	0.005181347	66	not available	no	not available	round	circumscribed	isoechoic	no	no	no	no	Cyst filled with thick fluid&Dysplasia&Fibroadenoma	3	confirmed by biopsy	Benign mammary dysplasia	benign
205	205	case205.png	case205_tumor.png	NaN	0.01078	80	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
206	206	case206.png	case206_tumor.png	NaN	0.01078	63	not available	not available	not available	irregular	not circumscribed - angular&indistinct	heterogeneous	enhancement	yes	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	5	confirmed by biopsy	Mucinous carcinoma	malignant
207	207	case207.png	case207_tumor.png	NaN	0.006076389	48	heterogeneous: predominantly fibroglandular	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Fibroadenoma	4a	confirmed by biopsy	Fibroadenoma	benign
208	208	case208.png	case208_tumor.png	NaN	0.005902192	not available	homogeneous: fibroglandular	no	not available	oval	circumscribed	heterogeneous	no	no	no	no	Intramammary lymph node	2	confirmed by follow-up care	not applicable	benign
209	209	case209.png	NaN	NaN	0.00726979	57	heterogeneous: predominantly fat	no	not available	not applicable	not applicable	not applicable	not applicable	not applicable	not applicable	no	not applicable	1	not applicable	not applicable	normal
210	210	case210.png	case210_tumor.png	NaN	0.0078125	56	heterogeneous: predominantly fat	no	no	round	circumscribed	heterogeneous	no	no	no	no	Complex cyst / Non-simple cyst&Cyst filled with thick fluid&Intraductal papilloma	4a	confirmed by biopsy	Fibrosclerosis	benign
211	211	case211.png	case211_tumor.png	NaN	0.006462036	not available	homogeneous: fat	no	no	irregular	not circumscribed - indistinct	hypoechoic	no	yes	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
212	212	case212.png	case212_tumor.png	NaN	0.0078125	51	heterogeneous: predominantly fat	skin retraction&palpable	nipple discharge	irregular	not circumscribed - spiculated&microlobulated&indistinct	hypoechoic	shadowing	yes	no	yes	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)&Ductal carcinoma in situ (DCIS)	malignant
213	213	case213.png	NaN	NaN	0.01035503	64	heterogeneous: predominantly fat	no	not available	not applicable	not applicable	not applicable	not applicable	not applicable	not applicable	no	not applicable	1	not applicable	not applicable	normal
214	214	case214.png	case214_tumor.png	NaN	0.006462036	not available	heterogeneous: predominantly fat	no	no	irregular	circumscribed	anechoic	enhancement	no	no	no	Complex cyst / Non-simple cyst&Dysplasia&Mammary duct ectasia	3	confirmed by follow-up care	not applicable	benign
215	215	case215.png	case215_tumor.png	NaN	0.008680556	62	heterogeneous: predominantly fibroglandular	palpable	no	irregular	not circumscribed - microlobulated	heterogeneous	no	no	no	no	Suspicion of malignancy&Fibroadenoma&Hamartoma	4b	confirmed by biopsy	Intraductal papilloma	benign
216	216	case216.png	case216_tumor.png	NaN	0.008680556	75	homogeneous: fat	palpable&breast scar	family history of breast/ovarian cancer	oval	circumscribed	anechoic	enhancement	no	no	yes	Seroma	2	confirmed by follow-up care	not applicable	benign
217	217	case217.png	case217_tumor.png	NaN	0.005910165	30	heterogeneous: predominantly fibroglandular	no	no	irregular	not circumscribed - microlobulated	heterogeneous	no	no	no	no	Dysplasia&Fibroadenoma	4b	confirmed by biopsy	Fibroadenoma	benign
218	218	case218.png	case218_tumor.png	NaN	0.01078	85	not available	not available	not available	irregular	not circumscribed - angular&indistinct	hypoechoic	shadowing	yes	no	yes	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
219	219	case219.png	case219_tumor.png	NaN	0.008680556	42	heterogeneous: predominantly fat	palpable	family history of breast/ovarian cancer&HRT/hormonal contraception	irregular	not circumscribed - angular&microlobulated&indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
220	220	case220.png	case220_tumor.png	NaN	0.008680556	61	homogeneous: fat	no	no	irregular	not circumscribed - indistinct	hypoechoic	shadowing	yes	no	no	Suspicion of malignancy&Intraductal papilloma	5	confirmed by biopsy	Atypical lobular hyperplasia (ALH)	benign
221	221	case221.png	case221_tumor.png	NaN	0.01078	62	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	shadowing	yes	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	5	confirmed by biopsy	Invasive lobular carcinoma	malignant
222	222	case222.png	case222_tumor.png	NaN	0.0078125	70	not available	no	family history of breast/ovarian cancer	oval	circumscribed	complex cystic/solid	no	no	no	no	Fat necrosis&Hematoma	3	confirmed by follow-up care	not applicable	benign
223	223	case223.png	case223_tumor.png	NaN	0.006076389	46	heterogeneous: predominantly fibroglandular	no	family history of breast/ovarian cancer	oval	circumscribed	hypoechoic	no	no	no	no	Fibroadenoma	3	confirmed by follow-up care	not applicable	benign
224	224	case224.png	case224_tumor.png	NaN	0.006688963	49	heterogeneous: predominantly fibroglandular	palpable	no	oval	circumscribed	anechoic	enhancement	no	no	no	Simple cyst&Complex cyst / Non-simple cyst	2	confirmed by follow-up care	not applicable	benign
225	225	case225.png	case225_tumor.png	NaN	0.0078125	63	heterogeneous: predominantly fibroglandular	palpable	HRT/hormonal contraception	irregular	not circumscribed - angular&indistinct	heterogeneous	no	yes	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)&Apocrine carcinoma	malignant
226	226	case226.png	case226_tumor.png	NaN	0.0078125	62	heterogeneous: predominantly fat	palpable	no	irregular	not circumscribed - microlobulated	hypoechoic	no	no	no	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
227	227	case227.png	case227_tumor.png	NaN	0.008680556	86	homogeneous: fat	palpable	no	irregular	not circumscribed - spiculated&angular&indistinct	hypoechoic	shadowing	yes	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive lobular carcinoma	malignant
228	228	case228.png	case228_tumor.png	NaN	0.0078125	43	homogeneous: fibroglandular	no	nipple discharge	irregular	not circumscribed - spiculated	heterogeneous	no	no	in a mass	no	Suspicion of malignancy&Dysplasia&Duct filled with thick fluid&Lacteal cyst	4b	confirmed by biopsy	Ductal carcinoma in situ (DCIS)&Solid papillary carcinoma in situ	malignant
229	229	case229.png	case229_tumor.png	NaN	0.006076389	20	homogeneous: fibroglandular	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Fibroadenoma	4a	confirmed by biopsy	Fibroadenosis	benign
230	230	case230.png	case230_tumor.png	NaN	0.00726979	not available	heterogeneous: predominantly fat	no	no	irregular	not circumscribed - angular&indistinct	hypoechoic	shadowing	yes	in a mass	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)&Mucinous carcinoma	malignant
231	231	case231.png	case231_tumor.png	NaN	0.0078125	23	homogeneous: fibroglandular	no	not available	oval	circumscribed	isoechoic	no	no	no	no	Fibroadenoma	4a	confirmed by biopsy	Fibroadenoma	benign
232	232	case232.png	case232_tumor.png	NaN	0.006462036	not available	not available	no	no	oval	circumscribed	isoechoic	enhancement	no	no	no	Dysplasia&Lipoma	4a	confirmed by biopsy	Benign mammary dysplasia	benign
233	233	case233.png	case233_tumor.png	NaN	0.01078	25	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	enhancement	yes	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4b	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
234	234	case234.png	case234_tumor.png	NaN	0.005902192	not available	heterogeneous: predominantly fibroglandular	not available	not available	irregular	not circumscribed - angular&indistinct	hypoechoic	no	no	no	no	Suspicion of malignancy&Dysplasia&Mammary duct ectasia	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
235	235	case235.png	case235_tumor.png	NaN	0.006944444	50	homogeneous: fibroglandular	no	no	oval	circumscribed	hypoechoic	no	no	no	no	Cyst filled with thick fluid&Dysplasia&Fibroadenoma	2	confirmed by follow-up care	not applicable	benign
236	236	case236.png	case236_tumor.png	NaN	0.010362694	not available	heterogeneous: predominantly fat	no	not available	oval	circumscribed	hyperechoic	no	no	no	no	Lipoma	2	confirmed by follow-up care	not applicable	benign
237	237	case237.png	case237_tumor.png	NaN	0.006462036	21	heterogeneous: predominantly fibroglandular	no	not available	oval	circumscribed	anechoic	enhancement	no	no	no	Simple cyst	2	confirmed by follow-up care	not applicable	benign
238	238	case238.png	case238_tumor.png	NaN	0.0078125	55	heterogeneous: predominantly fibroglandular	no	no	irregular	not circumscribed - spiculated	hypoechoic	no	yes	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
239	239	case239.png	case239_tumor.png	NaN	0.01078	76	not available	not available	not available	irregular	not circumscribed - indistinct	hypoechoic	combined	yes	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	5	confirmed by biopsy	Invasive lobular carcinoma	malignant
240	240	case240.png	case240_tumor.png	NaN	0.00726979	not available	lactating&homogeneous: fibroglandular	no	not available	oval	not circumscribed - indistinct	hypoechoic	shadowing	no	no	no	Fibroadenoma&Lactating adenoma	3	confirmed by follow-up care	not applicable	benign
241	241	case241.png	case241_tumor.png	NaN	0.005208333	43	homogeneous: fibroglandular	no	no	round	circumscribed	heterogeneous	no	no	no	no	Complex cyst / Non-simple cyst&Cyst filled with thick fluid&Dysplasia&Duct filled with thick fluid	3	confirmed by follow-up care	not applicable	benign
242	242	case242.png	case242_tumor.png	NaN	0.005181347	48	homogeneous: fibroglandular	no	not available	oval	circumscribed	heterogeneous	no	no	no	no	Fibroadenoma&Duct filled with thick fluid	3	confirmed by follow-up care	not applicable	benign
243	243	case243.png	case243_tumor.png	NaN	0.00924	66	not available	not available	not available	irregular	not circumscribed - angular&indistinct	heterogeneous	shadowing	yes	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
244	244	case244.png	case244_tumor.png	NaN	0.006462036	not available	heterogeneous: predominantly fat	no	no	irregular	not circumscribed - microlobulated&indistinct	hypoechoic	no	no	in a mass	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
245	245	case245.png	case245_tumor.png	NaN	0.00924	57	not available	not available	not available	irregular	not circumscribed - angular&indistinct	heterogeneous	enhancement	no	no	no	Suspicion of malignancy&Fibroadenoma&Intraductal papilloma	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
246	246	case246.png	case246_tumor.png	NaN	0.006462036	not available	heterogeneous: predominantly fat	no	no	irregular	not circumscribed - angular&indistinct	hypoechoic	shadowing	no	no	no	Suspicion of malignancy	5	confirmed by biopsy	Benign mammary dysplasia	benign
247	247	case247.png	case247_tumor.png	NaN	0.008680556	73	homogeneous: fat	palpable	family history of breast/ovarian cancer	irregular	not circumscribed - spiculated&indistinct	hypoechoic	no	yes	in a mass	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
248	248	case248.png	case248_tumor.png	NaN	0.0078125	43	homogeneous: fibroglandular	palpable	no	irregular	not circumscribed - spiculated&microlobulated&indistinct	hypoechoic	no	no	in a mass	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
249	249	case249.png	case249_tumor.png	NaN	0.006944444	87	not available	palpable	no	irregular	not circumscribed - microlobulated&indistinct	complex cystic/solid	no	yes	in a mass	no	Suspicion of malignancy	4c	confirmed by biopsy	Invasive papillary carcinoma&Encapsulated papillary carcinoma	malignant
250	250	case250.png	case250_tumor.png	NaN	0.006462036	not available	not available	no	no	irregular	not circumscribed - indistinct	heterogeneous	no	no	no	no	Suspicion of malignancy&Dysplasia	4c	confirmed by biopsy	Invasive lobular carcinoma	malignant
251	251	case251.png	case251_tumor.png	NaN	0.006462036	not available	heterogeneous: predominantly fat	palpable	no	irregular	not circumscribed - angular&microlobulated	hypoechoic	no	no	no	yes	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)	malignant
252	252	case252.png	case252_tumor.png	NaN	0.006944444	18	homogeneous: fibroglandular	palpable	no	oval	circumscribed	hypoechoic	no	no	no	no	Fibroadenoma	4a	confirmed by biopsy	Fibroadenoma	benign
253	253	case253.png	case253_tumor.png	NaN	0.0078125	64	homogeneous: fat	palpable&breast scar	family history of breast/ovarian cancer	oval	circumscribed	anechoic	enhancement	no	no	yes	Fat necrosis&Breast scar (surgery)	2	confirmed by follow-up care	not applicable	benign
254	254	case254.png	case254_tumor.png	NaN	0.0078125	57	heterogeneous: predominantly fat	no	no	irregular	not circumscribed - microlobulated&indistinct	hypoechoic	shadowing	no	no	no	Suspicion of malignancy	5	confirmed by biopsy	Invasive carcinoma of no special type (NST)&Ductal carcinoma in situ (DCIS)	malignant
255	255	case255.png	case255_tumor.png	NaN	0.006944444	42	heterogeneous: predominantly fibroglandular	palpable	family history of breast/ovarian cancer	irregular	not circumscribed - microlobulated&indistinct	heterogeneous	shadowing	no	intraductal	no	Suspicion of malignancy&Mastitis	4c	confirmed by biopsy	Ductal carcinoma in situ (DCIS)	malignant
256	256	case256.png	case256_tumor.png	NaN	0.0078125	38	homogeneous: fibroglandular	palpable	HRT/hormonal contraception	oval	circumscribed	heterogeneous	no	no	no	no	Fibroadenoma	4a	confirmed by biopsy	Fibroadenoma	benign
\.


--
-- Data for Name: ds_3_product_inventory_4205c3ea; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ds_3_product_inventory_4205c3ea (id, sku, product_name, category, brand, stock_qty, reorder_level, unit_cost, selling_price, warehouse, last_restocked) FROM stdin;
1	SKU-1001	Laptop Pro 15 i7	Electronics	TechBrand	45	10	850	1299.99	WH-A	2024-01-10
2	SKU-1002	Wireless Mouse Slim	Accessories	ClickTech	230	50	12.5	39.99	WH-B	2024-01-08
3	SKU-1003	USB-C Dock Pro	Accessories	ConnectHub	78	20	28	79.99	WH-A	2024-01-15
4	SKU-1004	27" 4K Monitor	Electronics	ViewClear	32	8	320	549.99	WH-C	2024-01-05
5	SKU-1005	Office Chair Mesh	Furniture	ErgoSeat	19	5	180	349	WH-B	2024-01-12
6	SKU-1006	Standing Desk Motorised	Furniture	DeskRise	11	3	350	699	WH-C	2024-01-20
7	SKU-1007	Noise Cancel Headset	Electronics	SoundPro	54	15	145	279.99	WH-A	2024-01-18
8	SKU-1008	Mechanical KB TKL	Accessories	KeyForce	91	25	65	129.99	WH-B	2024-01-22
9	SKU-1009	Webcam 4K AutoFocus	Electronics	LensTech	37	10	55	119.99	WH-A	2024-01-25
10	SKU-1010	Cable Mgmt Tray	Accessories	NeatDesk	156	40	8	22.99	WH-C	2024-01-28
11	SKU-1011	Portable SSD 2TB	Electronics	SpeedDrive	63	20	70	149.99	WH-A	2024-02-01
12	SKU-1012	Laptop Backpack 17L	Accessories	TravelPro	44	15	25	59.99	WH-B	2024-02-03
13	SKU-1013	Smart LED Desk Lamp	Furniture	BrightSpace	82	20	18	44.99	WH-C	2024-02-05
14	SKU-1014	GPU RTX 4070	Electronics	NvidiaOEM	9	3	480	699.99	WH-A	2024-02-08
15	SKU-1015	HDMI 2.1 Cable 2m	Accessories	CableMax	310	80	3.5	12.99	WH-B	2024-02-10
16	SKU-1016	Monitor Privacy Filter	Accessories	PrivaShield	26	10	22	54.99	WH-C	2024-02-12
17	SKU-1017	USB-A Hub 7 Port	Accessories	ConnectHub	185	50	9	24.99	WH-A	2024-02-15
18	SKU-1018	Ergonomic Wrist Rest	Accessories	ComfortType	67	20	6	18.99	WH-B	2024-02-18
19	SKU-1019	24" IPS Monitor	Electronics	ViewClear	28	8	210	379.99	WH-C	2024-02-20
20	SKU-1020	Laptop Cooling Pad	Accessories	CoolBreeze	55	15	14	34.99	WH-A	2024-02-22
\.


--
-- Data for Name: ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8 (id, caseid, image_filename, mask_tumor_filename, mask_other_filename, pixel_size, age, tissue_composition, signs, symptoms, shape, margin, echogenicity, posterior_features, halo, calcifications, skin_thickening, interpretation, birads, verification, diagnosis, classification) FROM stdin;
\.


--
-- Data for Name: ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1 (id, caseid, image_filename, mask_tumor_filename, mask_other_filename, pixel_size, age, tissue_composition, signs, symptoms, shape, margin, echogenicity, posterior_features, halo, calcifications, skin_thickening, interpretation, birads, verification, diagnosis, classification) FROM stdin;
\.


--
-- Data for Name: ds_4_product_inventory_0eb0727a; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ds_4_product_inventory_0eb0727a (id, sku, product_name, category, brand, stock_qty, reorder_level, unit_cost, selling_price, warehouse, last_restocked) FROM stdin;
1	SKU-1001	Laptop Pro 15 i7	Electronics	TechBrand	45	10	850	1299.99	WH-A	2024-01-10
2	SKU-1002	Wireless Mouse Slim	Accessories	ClickTech	230	50	12.5	39.99	WH-B	2024-01-08
3	SKU-1003	USB-C Dock Pro	Accessories	ConnectHub	78	20	28	79.99	WH-A	2024-01-15
4	SKU-1004	27" 4K Monitor	Electronics	ViewClear	32	8	320	549.99	WH-C	2024-01-05
5	SKU-1005	Office Chair Mesh	Furniture	ErgoSeat	19	5	180	349	WH-B	2024-01-12
6	SKU-1006	Standing Desk Motorised	Furniture	DeskRise	11	3	350	699	WH-C	2024-01-20
7	SKU-1007	Noise Cancel Headset	Electronics	SoundPro	54	15	145	279.99	WH-A	2024-01-18
8	SKU-1008	Mechanical KB TKL	Accessories	KeyForce	91	25	65	129.99	WH-B	2024-01-22
9	SKU-1009	Webcam 4K AutoFocus	Electronics	LensTech	37	10	55	119.99	WH-A	2024-01-25
10	SKU-1010	Cable Mgmt Tray	Accessories	NeatDesk	156	40	8	22.99	WH-C	2024-01-28
11	SKU-1011	Portable SSD 2TB	Electronics	SpeedDrive	63	20	70	149.99	WH-A	2024-02-01
12	SKU-1012	Laptop Backpack 17L	Accessories	TravelPro	44	15	25	59.99	WH-B	2024-02-03
13	SKU-1013	Smart LED Desk Lamp	Furniture	BrightSpace	82	20	18	44.99	WH-C	2024-02-05
14	SKU-1014	GPU RTX 4070	Electronics	NvidiaOEM	9	3	480	699.99	WH-A	2024-02-08
15	SKU-1015	HDMI 2.1 Cable 2m	Accessories	CableMax	310	80	3.5	12.99	WH-B	2024-02-10
16	SKU-1016	Monitor Privacy Filter	Accessories	PrivaShield	26	10	22	54.99	WH-C	2024-02-12
17	SKU-1017	USB-A Hub 7 Port	Accessories	ConnectHub	185	50	9	24.99	WH-A	2024-02-15
18	SKU-1018	Ergonomic Wrist Rest	Accessories	ComfortType	67	20	6	18.99	WH-B	2024-02-18
19	SKU-1019	24" IPS Monitor	Electronics	ViewClear	28	8	210	379.99	WH-C	2024-02-20
20	SKU-1020	Laptop Cooling Pad	Accessories	CoolBreeze	55	15	14	34.99	WH-A	2024-02-22
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, full_name, email, hashed_password, plan, is_active, is_admin, trial_ends_at, created_at, google_id, stripe_customer_id, stripe_subscription_id) FROM stdin;
1	Admin User	admin@docapi.com	$2b$12$dzMPkahQhJwVAgUbPFd91OEORMK38b/Va1p3R704MiVmnIEXkcfve	pro	t	t	\N	2026-05-13 14:03:00.114266+01	\N	\N	\N
2	Alice Johnson	alice@example.com	$2b$12$mMiN3qaBHzo6mhDffW4fpOgXDGmDNS0ZVs6wpKpCUrUlfRMgO8kdW	premium	t	f	\N	2026-05-13 14:03:00.460295+01	\N	\N	\N
3	Bob Smith	bob@example.com	$2b$12$/HWhskRtm/X8M5ld0HI0NOk0p0hrV/8gV8GncueXGMHYl89sC9byG	free	t	f	\N	2026-05-13 14:03:00.800175+01	\N	\N	\N
4	Carol Williams	carol@example.com	$2b$12$5V.iedjZf9Z3oEDI6xudqecxgQuNHNTj3JSV36/MjFiD2zvAK9ee2	pro	t	f	\N	2026-05-13 14:03:01.140691+01	\N	\N	\N
\.


--
-- Name: api_keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.api_keys_id_seq', 9, true);


--
-- Name: api_usage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.api_usage_id_seq', 1176, true);


--
-- Name: conversation_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.conversation_messages_id_seq', 20, true);


--
-- Name: datasets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.datasets_id_seq', 13, true);


--
-- Name: ds_1_employees_seed_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ds_1_employees_seed_id_seq', 60, true);


--
-- Name: ds_1_invoices_seed_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ds_1_invoices_seed_id_seq', 120, true);


--
-- Name: ds_1_sales_orders_a50a19dd_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ds_1_sales_orders_a50a19dd_id_seq', 20, true);


--
-- Name: ds_1_test_74ec9ab8_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ds_1_test_74ec9ab8_id_seq', 1, false);


--
-- Name: ds_2_products_seed_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ds_2_products_seed_id_seq', 80, true);


--
-- Name: ds_2_sales_seed_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ds_2_sales_seed_id_seq', 200, true);


--
-- Name: ds_3_breast_dataset_c6c9cc35_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ds_3_breast_dataset_c6c9cc35_id_seq', 256, true);


--
-- Name: ds_3_product_inventory_4205c3ea_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ds_3_product_inventory_4205c3ea_id_seq', 20, true);


--
-- Name: ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8_id_seq', 1, false);


--
-- Name: ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1_id_seq', 1, false);


--
-- Name: ds_4_product_inventory_0eb0727a_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ds_4_product_inventory_0eb0727a_id_seq', 20, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: api_usage api_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_usage
    ADD CONSTRAINT api_usage_pkey PRIMARY KEY (id);


--
-- Name: conversation_messages conversation_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation_messages
    ADD CONSTRAINT conversation_messages_pkey PRIMARY KEY (id);


--
-- Name: datasets datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT datasets_pkey PRIMARY KEY (id);


--
-- Name: datasets datasets_table_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT datasets_table_name_key UNIQUE (table_name);


--
-- Name: ds_1_employees_seed ds_1_employees_seed_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_1_employees_seed
    ADD CONSTRAINT ds_1_employees_seed_pkey PRIMARY KEY (id);


--
-- Name: ds_1_invoices_seed ds_1_invoices_seed_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_1_invoices_seed
    ADD CONSTRAINT ds_1_invoices_seed_pkey PRIMARY KEY (id);


--
-- Name: ds_1_sales_orders_a50a19dd ds_1_sales_orders_a50a19dd_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_1_sales_orders_a50a19dd
    ADD CONSTRAINT ds_1_sales_orders_a50a19dd_pkey PRIMARY KEY (id);


--
-- Name: ds_1_test_74ec9ab8 ds_1_test_74ec9ab8_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_1_test_74ec9ab8
    ADD CONSTRAINT ds_1_test_74ec9ab8_pkey PRIMARY KEY (id);


--
-- Name: ds_2_products_seed ds_2_products_seed_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_2_products_seed
    ADD CONSTRAINT ds_2_products_seed_pkey PRIMARY KEY (id);


--
-- Name: ds_2_sales_seed ds_2_sales_seed_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_2_sales_seed
    ADD CONSTRAINT ds_2_sales_seed_pkey PRIMARY KEY (id);


--
-- Name: ds_3_breast_dataset_c6c9cc35 ds_3_breast_dataset_c6c9cc35_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_3_breast_dataset_c6c9cc35
    ADD CONSTRAINT ds_3_breast_dataset_c6c9cc35_pkey PRIMARY KEY (id);


--
-- Name: ds_3_product_inventory_4205c3ea ds_3_product_inventory_4205c3ea_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_3_product_inventory_4205c3ea
    ADD CONSTRAINT ds_3_product_inventory_4205c3ea_pkey PRIMARY KEY (id);


--
-- Name: ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8 ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8
    ADD CONSTRAINT ds_4_breast_lesions_usg_clinical_data_dec_15__524328a8_pkey PRIMARY KEY (id);


--
-- Name: ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1 ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1
    ADD CONSTRAINT ds_4_breast_lesions_usg_clinical_data_dec_15__677d42e1_pkey PRIMARY KEY (id);


--
-- Name: ds_4_product_inventory_0eb0727a ds_4_product_inventory_0eb0727a_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ds_4_product_inventory_0eb0727a
    ADD CONSTRAINT ds_4_product_inventory_0eb0727a_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ix_api_keys_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_api_keys_id ON public.api_keys USING btree (id);


--
-- Name: ix_api_keys_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_api_keys_user_id ON public.api_keys USING btree (user_id);


--
-- Name: ix_api_usage_api_key_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_api_usage_api_key_id ON public.api_usage USING btree (api_key_id);


--
-- Name: ix_api_usage_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_api_usage_created_at ON public.api_usage USING btree (created_at);


--
-- Name: ix_api_usage_dataset_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_api_usage_dataset_id ON public.api_usage USING btree (dataset_id);


--
-- Name: ix_api_usage_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_api_usage_id ON public.api_usage USING btree (id);


--
-- Name: ix_conversation_messages_dataset_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_conversation_messages_dataset_id ON public.conversation_messages USING btree (dataset_id);


--
-- Name: ix_conversation_messages_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_conversation_messages_id ON public.conversation_messages USING btree (id);


--
-- Name: ix_datasets_custom_endpoint; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_datasets_custom_endpoint ON public.datasets USING btree (custom_endpoint) WHERE (custom_endpoint IS NOT NULL);


--
-- Name: ix_datasets_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_datasets_id ON public.datasets USING btree (id);


--
-- Name: ix_datasets_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_datasets_user_id ON public.datasets USING btree (user_id);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: api_keys api_keys_dataset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_dataset_id_fkey FOREIGN KEY (dataset_id) REFERENCES public.datasets(id);


--
-- Name: api_keys api_keys_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: api_usage api_usage_api_key_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_usage
    ADD CONSTRAINT api_usage_api_key_id_fkey FOREIGN KEY (api_key_id) REFERENCES public.api_keys(id);


--
-- Name: api_usage api_usage_dataset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_usage
    ADD CONSTRAINT api_usage_dataset_id_fkey FOREIGN KEY (dataset_id) REFERENCES public.datasets(id);


--
-- Name: conversation_messages conversation_messages_dataset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation_messages
    ADD CONSTRAINT conversation_messages_dataset_id_fkey FOREIGN KEY (dataset_id) REFERENCES public.datasets(id);


--
-- Name: datasets datasets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT datasets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict yQ9PNXYmA2r8GD4MBJmunmVjVHX5tlEyKIKmjWpTdrP3k425l2oS22nOD9Bnibq

