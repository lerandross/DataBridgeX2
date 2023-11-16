import streamlit as st
import sqlite3
from pgs.home import pg_home
from pgs.configs.pg_config import pg_config



def page_changer(page:str):
    st.session_state['page'] = page

def main():
    
    logo = '''
        <div style="display: flex; align-items: center; justify-content: center; height: 10vh; margin: 0;margin-bottom: 10px; text-align: center;">
            <img src="https://cdn.pixabay.com/animation/2022/07/29/03/42/03-42-11-849_512.gif" alt="Imagem" style="width: 100px; height: 100;">
        </div>
    '''

    col1st, col2st = st.sidebar.columns(2)
    st.sidebar.markdown(logo, unsafe_allow_html=True)
    #col2st.markdown('### DataBridgeX 2', unsafe_allow_html=True)
    st.sidebar.button('🏠 Home', key=1, use_container_width=True, on_click=page_changer, args=('pg_home',))
    st.sidebar.button('⌚ Atualizador', key=2, use_container_width=True)
    st.sidebar.button('⚙️ Configuração', key=3, use_container_width=True, on_click=page_changer, args=('pg_config',))
    st.sidebar.button('📓 Logs', key=4, use_container_width=True)

    if st.session_state['page'] in 'pg_home':
        pg_home()
    if st.session_state['page'] in 'pg_config':
        pg_config()




conexao = sqlite3.connect('DataBridge.db')

if not 'page' in st.session_state:
    st.session_state['page'] = 'pg_home'


main()