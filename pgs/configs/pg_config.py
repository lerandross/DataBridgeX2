import streamlit as st


def pg_config():
    st.title('Configuração')

    c1_header, c2_header = st.columns(2)
    c1_header.button('Adicionar Novo', )
    st.selectbox('Banco',['Mysql','SQL Server',])
    st.text_area(label='IP', value='0.0.0.0', key=5)
    st.text_area(label='Query', value='select * from *', key=6)
    st.text_area(label='Query', value='select * from *', key=7)